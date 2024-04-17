import SwiftUI

struct BookView: View {
    @State private var animatoinContent: Bool = false
    @State private var offsetAnimation: Bool = false
    
    @Binding var show: Bool
    var animation: Namespace.ID
    var animeBook: AnimeBook
    let fileName: String
    
    @State private var selectedSegment = 1
    
    @State private var book: Book = Book(book: MultilingualText(en: "", zh: ""), theme: MultilingualText(en: "", zh: ""), introduction: MultilingualText(en: "", zh: ""), chapters: [])
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    offsetAnimation = false
                }
                
                /// Closing Detail View
                withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                    animatoinContent = false
                    show = false
                }
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
                    Image(animeBook.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    /// Since padding horizontal is 15, which means 15 on the left and 15 on the right, the total is 30
                        .frame(width: (size.width - 30) / 2, height: size.height)
                    /// Custom Corner Shape
                        .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                    /// Matched Geometry ID
                        .matchedGeometryEffect(id: animeBook.id, in: animation)
                    
                    /// Book Details
                    VStack(alignment: .leading, spacing: 8) {
                        SpeakButton(text: book.book.en, speechLang: .en, font: .title2)
                        
                        SpeakButton(text: book.book.zh, speechLang: .zh, font: .title2)
                        
                        
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
                    }
                    .padding(.trailing, 15)
                    .padding(.top, 30)
                    .offset(y: offsetAnimation ? 0 : 100)
                    .opacity(offsetAnimation ? 1 : 0)
                }
            }
            .frame(height: BooksView.cardHeight)
            /// Placing it Above
            .zIndex(1)
            
            Rectangle()
                .fill(Color.background)
                .ignoresSafeArea()
                .overlay(alignment: .top, content: {
                    if selectedSegment == 0 {
                        List {
                            SpeakButton(text: showThemeOrIntro(theme: book.theme.en, intro: book.introduction.en), speechLang: .en)
                            
                            SpeakButton(text: showThemeOrIntro(theme: book.theme.zh, intro: book.introduction.zh), speechLang: .zh)
                        }
                        .listStyle(.plain)
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: columns) {
                                ForEach(book.chapters) { chapter in
                                    NavigationLink(destination: ChapterView(chapter: chapter, bookTitle: book.book)) {
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
        .animation(.linear, value: selectedSegment)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(Color.background)
                .ignoresSafeArea()
                .opacity(animatoinContent ? 1 : 0)
        }
        .onAppear {
            loadChapters()
            
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
            SpeechUtil.share.stopSpeaking()
        }
    }
    
    func showThemeOrIntro(theme: String, intro: String) -> String {
        return theme.count > intro.count ? theme : intro
    }
    
    func loadChapters() {
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "Scriptures/BookOfMormon") else {
            print("File \(fileName) not found in the bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let book = try JSONDecoder().decode(Book.self, from: data)
            self.book = book
        } catch {
            print("Error loading chapters: \(error)")
        }
    }
}
