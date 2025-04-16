//
//  BooksView.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-03.
//

import SwiftUI
import FirebaseAnalytics

struct BooksView: View {
    static let cardHeight: CGFloat = (UIScreen.main.bounds.width - 40) / 9 * 7
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var isIpad: Bool {
        horizontalSizeClass == .regular
    }
    
    /// View Properties
    @State private var carouselMode: Bool = false
    /// For Matched Geometry Effect
    @Namespace private var animation
    /// Detail View Properties
    @State private var showDetailView: Bool = false
    @State private var selectedBook: AnimeBook?
    @State private var animationCurrentBook: Bool = false
    
    var body: some View {
        NavigationStack {
            ResponsiveView { props in
                VStack(spacing: 15) {
                    
                    VStack(spacing: 0) {
                        HStack {
                            Image("Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .clipShape(.circle)
                                .cornerRadius(16)
                           
                            Text("Bilingual Bible")
                                .font(.title2.bold())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        
                        if settingsViewModel.isLdsBooksVisible {
                            ScrollableTabBar(tabContents: [
                                buildScrollingBookView(animeBooks: sampleBOFM, props: props),
                                buildScrollingBookView(animeBooks: sampleDC, props: props),
                                buildScrollingBookView(animeBooks: samplePGP, props: props),
                                buildScrollingBookView(animeBooks: sampleOT, props: props),
                                buildScrollingBookView(animeBooks: sampleNT, props: props)
                            ], tabs: [
                                .init(id: TabModel.Tab.bofm),
                                .init(id: TabModel.Tab.dc),
                                .init(id: TabModel.Tab.pgp),
                                .init(id: TabModel.Tab.ot),
                                .init(id: TabModel.Tab.nt)
                            ])
                        } else {
                            ScrollableTabBar(tabContents: [
                                buildScrollingBookView(animeBooks: sampleOT, props: props),
                                buildScrollingBookView(animeBooks: sampleNT, props: props)
                            ], tabs: [
                                .init(id: TabModel.Tab.ot),
                                .init(id: TabModel.Tab.nt)
                            ])
                        }
                    }
                }
                .overlay {
                    if let selectedBook, showDetailView
                    {
                        BookView(show: $showDetailView, animation: animation, animeBook: selectedBook)
                        //                DetailView(show: $showDetailView, animation: animation, book: selectedBook)
                        /// For More Fluent Animation Transition
                            .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
                    }
                }
                .onChange(of: showDetailView) { _, newValue in
                    if !newValue {
                        /// Resetting Book Animation
                        /// When the detail view is closed, the book offset is rest to zero (this why the delay is used)
                        withAnimation(.easeInOut(duration: 0.15).delay(0.4))
                        {
                            animationCurrentBook = false
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func buildScrollingBookView(animeBooks :[AnimeBook], props: Properties) -> some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: props.columnCount)
        
        GeometryReader {
            let size = $0.size
            
            ScrollView(.vertical, showsIndicators: false) {
                /// Books Card View
                LazyVGrid(columns: columns,spacing: 35) {
                    ForEach(animeBooks)
                    {
                        book in
                        BookCardView(book, props: props)
                        /// Opening Detail View, When Ever Card is Tapped
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2))
                                {
                                    animationCurrentBook = true
                                    selectedBook = book
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7))
                                    {
                                        showDetailView = true
                                    }
                                }
                                Analytics.logEvent("open_book", parameters: [
                                    "Book": book.bookName as NSObject
                                ])
                            }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
                .padding(.bottom, bottomPadding(size, props: props))
                .background {
                    ScrollViewDetector(carouselMode: $carouselMode, totalCardCount: animeBooks.count)
                }
            }
            /// Since we need offset from here and not from global View
            .coordinateSpace(name: "SCROLLVIEW")
            
        }
        .padding(.top, 15)
    }
    
    /// Bottom Padding for last card to move up to the top
    func bottomPadding(_ size: CGSize = .zero, props: Properties) -> CGFloat {
        let scrollViewHeight: CGFloat = size.height
        
        /*
            Thus, we need to show the last card, so we're removing one card's height from the scrollview total height
            That -20 came from the vertical padding of 20, so if we remove the 40 (vertical padding 20), then we will have the top stating point, which is 20
         */
        return scrollViewHeight - props.cardHeight - 40
    }
    
    /// Book Card View
    @ViewBuilder
    func BookCardView(_ book: AnimeBook, props: Properties) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            /// Rotation Animation Based on Scroll Position
            // let minY = rect.minY
            
            HStack(spacing: -25) {
                /// Book Detail Card
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.engTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(book.zhoTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text(book.period)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.background)
                    /// Applying Shadow
                        .shadow(color: .primary.opacity(0.12), radius: 8, x: 5, y: 5)
                        .shadow(color: .primary.opacity(0.12), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                /// Moving the book, if it's tapped
                .offset(x: animationCurrentBook && selectedBook?.id == book.id ? -20 : 0)
//                .overlay {
//                    Text("\(minY)")
//                }
                
                /// Book Cover Image
                ZStack {
                    if !(showDetailView && selectedBook?.id == book.id) {
                        Image(book.bookName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            /// Matched Geometry ID
                            .matchedGeometryEffect(id: book.id, in: animation)
                            /// Applying Shadow
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                }
            }
            .frame(width: size.width)
            .if(!isIpad) { view in
                view.rotation3DEffect(
                    .degrees(convertOffsetToRotation(rect)),
                    axis: (x: 1, y: 0, z: 0),
                    anchor: .bottom,
                    anchorZ: 1,
                    perspective: 0.8
                )
            }
        }
        .frame(height: props.cardHeight)
    }
    
    /// Converting MinY to Rotation
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        /*
            That's because since we removed 20 from the minY, we need to add it to the
            height in order to get the proper rotation complete
         */
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        /*
            As we don't want to do any rotation for any other cards,
            we only need to do with the first one, so when the offset ges beyond zero,
            we're applying rotation animation to the card
         */
        let progress = minY < 0 ? (minY / cardHeight) : 0
        /*
            Limiting progress from 0 to 1, since our offset is negative value,
            thus converting into a positive one
         */
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90
    }
}

#Preview {
    BooksView()
}
