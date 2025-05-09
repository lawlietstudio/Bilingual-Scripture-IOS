import SwiftUI
import Combine

struct BookView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var speechViewModel: SpeechViewModel
    
    var isIpad: Bool {
        horizontalSizeClass == .regular
    }
    
    @State private var animatoinContent: Bool = false
    @State private var offsetAnimation: Bool = false
    
    @Binding var show: Bool
    var animation: Namespace.ID
    var animeBook: AnimeBook
    
    @State private var selectedSegment = 1
    
    @State private var book: Book = Book(book: MultilingualText(fr: "", en: "", zh: "", jp: "", kr: ""), theme: MultilingualText(fr: "", en: "", zh: "", jp: "", kr: ""), introduction: MultilingualText(fr: "", en: "", zh: "", jp: "", kr: ""), chapters: [])
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    var body: some View {
        ResponsiveView { props in
            let factor: CGFloat = CGFloat(props.columnCount) * 2
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: props.columnCount * 5)
            
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismissBook()
                } label: {
                    Image(systemName: "multiply")
                        .font(.title)
                    //                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                        .contentShape(Rectangle())
                }
                .padding(.top, 7)
                .padding([.leading, .bottom], 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animatoinContent ? 1 : 0)
                
                /// Book Preview (With Matched Geometry Effect)
                GeometryReader {
                    let size = $0.size
                    
                    HStack(spacing: 20) {
                        Image(animeBook.bookName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        /// Since padding horizontal is 15, which means 15 on the left and 15 on the right, the total is 30
                            .frame(width: (size.width - 30) / factor, height: size.height)
                        /// Custom Corner Shape
                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                        /// Matched Geometry ID
                            .matchedGeometryEffect(id: animeBook.id, in: animation)
                        
                        /// Book Details
                        VStack(alignment: .leading, spacing: 8) {
                            SpeakButton(text: animeBook.engTitle, speechLang: .en, font: .title2)
                            
                            SpeakButton(text: animeBook.zhoTitle, speechLang: .zh, font: .title2)
                            
                            SpeakButton(text: animeBook.period, speechLang: .en, font: .caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Picker("Options", selection: $selectedSegment) {
                                Text("Intro")
                                    .tag(0)
                                Text("Chapters")
                                    .tag(1)
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 300)
                        }
                        .padding(.trailing, 15)
                        .padding(.top, 30)
                        .offset(y: offsetAnimation ? 0 : 100)
                        .opacity(offsetAnimation ? 1 : 0)
                    }
                }
                .frame(height: props.cardHeight)
                /// Placing it Above
                .zIndex(1)
                
                Rectangle()
                    .fill(Color.background)
                    .ignoresSafeArea()
                    .overlay(alignment: .top, content: {
                        if selectedSegment == 0 {
                            List {
                                SpeakSection(themeMultilingualText: book.theme, introMultilingualText: book.introduction)
                            }
                            .listStyle(.plain)
                        } else {
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: columns) {
                                    ForEach(book.chapters) { chapter in
                                        NavigationLink(destination: ChapterTabview(chapters: book.chapters, animeBook: animeBook, selectedTab: chapter.number)) {
                                            Text("\(chapter.number)")
                                                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50)
                                                .foregroundColor(Color(UIColor.systemBackground))
                                                .background(
                                                    LinearGradient(gradient: Gradient(colors: [.primary, .primary]), startPoint: .top, endPoint: .bottom)
                                                )
                                                .cornerRadius(6)
                                                .shadow(radius: 2)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding()
                            }
                        }
                    })
                //                    .padding(.leading, 30)
                //                    /// Since we applied the negative padding to move the view up, we need to add the same padding in order to avoid view overlapping
                //                    .padding(.top, -180)
                    .zIndex(0)
                    .opacity(animatoinContent ? 1 : 0)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        //                    if value.translation.width > 150 {
                        dismissBook()
                        //                    }
                    }
            )
            .safeAreaPadding(.bottom, 16)
            .animation(.linear, value: selectedSegment)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                Rectangle()
                    .fill(Color.background)
                    .ignoresSafeArea()
                    .opacity(animatoinContent ? 1 : 0)
            }
            .task {
                await loadChapters()
                
                withAnimation(.easeInOut(duration: 0.35))
                {
                    animatoinContent = true
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.1))
                {
                    offsetAnimation = true
                }
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "BackgroundColor") ?? .black], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "AccentColor") ?? .black], for: .normal)
                /// The book details use different animations rather than opacity ones, so why a new variable? Since we need to display the details with a little delay, we introduced a new state rather than mixing the old one.
                
            }
            .onDisappear {
                speechViewModel.stopSpeaking()
            }
        }
    }
    
    func showThemeOrIntro(theme: MultilingualText, intro: MultilingualText) -> MultilingualText {
        return theme.en.count > intro.en.count ? theme : intro
    }
    
    func dismissBook() {
        withAnimation(.easeOut(duration: 0.2)) {
            offsetAnimation = false
        }
        
        /// Closing Detail View
        withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
            animatoinContent = false
            show = false
        }
    }
    
    func loadChapters() async {
        guard let fileUrl = Bundle.main.url(forResource: animeBook.bookName, withExtension: "json", subdirectory: "Scriptures/\(animeBook.scriptureName)") else {
            print("File \(animeBook.bookName) not found in the bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            let book = try JSONDecoder().decode(Book.self, from: data)
            self.book = book
        } catch {
            print("Error loading chapters: \(error)")
        }
    }
}
