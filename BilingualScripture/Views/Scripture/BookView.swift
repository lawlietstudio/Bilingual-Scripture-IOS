import SwiftUI
import Combine

struct BookView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    @EnvironmentObject var speechViewModel: SpeechViewModel
    
    var isIpad: Bool {
        horizontalSizeClass == .regular
    }
    
    @State private var animatoinContent: Bool = false
    @State private var offsetAnimation: Bool = false
    @State private var isLoadingChapters = true
    @State private var chapterLoadProgress: Double = 0
    
    @State private var totalIODuration: Double = 0
    @State private var totalParsingDuration: Double = 0
    
    @Binding var show: Bool
    var animation: Namespace.ID
    var animeBook: AnimeBook
    
    @State private var chapterNames: [Int] = []
    @State var chapters: [Chapter] = []
    
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
                            SpeakButton(text: languagesViewModel.localized(animeBook.localizedBookName), speechLang: SpeechLang.speechLang(for: languagesViewModel.primaryLanguage), font: .title2)
                            
                            SpeakButton(text: languagesViewModel.localized(animeBook.localizedBookName, isSecondary: true), speechLang: SpeechLang.speechLang(for: languagesViewModel.secondaryLanguage), font: .title2)
                            
                            SpeakButton(text: animeBook.period, speechLang: .en, font: .caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
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
                        if isLoadingChapters {
                            VStack(spacing: 12) {
//                                ProgressView()
//                                ProgressView(value: chapterLoadProgress)
//                                    .progressViewStyle(LinearProgressViewStyle())
//                                    .padding()
//                                Text("\(Int(chapterLoadProgress * 100))%")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: 150, maxHeight: .infinity)
                        } else {
                            ScrollView(showsIndicators: false) {
                                
                                LazyVGrid(columns: columns) {
                                    ForEach(chapters, id: \.id) { chapter in
                                        NavigationLink(destination: ChapterTabview(animeBook: animeBook, chapters: chapters, selectedTab: chapter.id)) {
                                            Text("\(chapter.id)")
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
            .animation(.linear, value: isLoadingChapters)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                Rectangle()
                    .fill(Color.background)
                    .ignoresSafeArea()
                    .opacity(animatoinContent ? 1 : 0)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.25)) {
                    animatoinContent = true
                }

                withAnimation(.easeInOut(duration: 0.35)) {
                    offsetAnimation = true
                }
            }
            .task {
                if self.chapters.isEmpty {
                    isLoadingChapters = true
                    Task.detached(priority: .background) {
                        await loadChaptersFromProtobuf()
                        try? await Task.sleep(nanoseconds: 50_000_000) // 0.1 second delay
                        await MainActor.run {
                            isLoadingChapters = false
                        }
                    }
                }
            }
            .onDisappear {
                speechViewModel.stopSpeaking()
            }
        }
    }
    
    func dismissBook() {
        withAnimation(.easeOut(duration: 0.35)) {
            offsetAnimation = false
        }
        
        /// Closing Detail View
        withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
            animatoinContent = false
            show = false
        }
    }
    
    func loadChaptersFromProtobuf() async {
        let folderPath = "protobuf/\(animeBook.category)/\(animeBook.bookName)"

        guard let folderURL = Bundle.main.url(forResource: folderPath, withExtension: nil) else {
            print("Folder not found.")
            return
        }

        do {
            let sortedFileNames = try await Task.detached(priority: .background) {
                let files = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                return files
                    .filter { $0.pathExtension == "bin" }
                    .map { $0.deletingPathExtension().lastPathComponent }
                    .compactMap { Int($0) }
                    .sorted()
                    .map { String($0) }
            }.value

            for (index, fileName) in sortedFileNames.enumerated() {
                if let chapter = await loadChapterFromProtobuf(fileName: fileName) {
                    await MainActor.run {
                        self.chapters.append(chapter)
                        self.chapterLoadProgress = Double(index + 1) / Double(sortedFileNames.count)
                    }
                }
            }

            print("📊 Total I/O time: \(totalIODuration) seconds")
            print("📊 Total parsing time: \(totalParsingDuration) seconds")

        } catch {
            print("Error reading Protobuf directory: \(error)")
        }
    }

    func loadChapterFromProtobuf(fileName: String) async -> Chapter? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "bin", subdirectory: "protobuf/\(animeBook.category)/\(animeBook.bookName)") else {
            print("Protobuf file not found: \(fileName)")
            return nil
        }

        do {
            let parseStartTime = CFAbsoluteTimeGetCurrent()
            let data = try Data(contentsOf: url)
            let protoChapter = try Scriptures_ChapterProto(serializedBytes: data)

//            let intro = protoChapter.intro.mapValues { $0.isEmpty == true ? nil : $0 }
            let intro = protoChapter.intro.mapValues { $0 }
//            let summary = protoChapter.summary.mapValues { $0.isEmpty == true ? nil : $0 }
            let summary = protoChapter.summary.mapValues { $0 }
            let verses: [[String: String?]] = protoChapter.verses.map { verse in
//                var dict = verse.translations.mapValues { $0.isEmpty == true ? nil : $0 }
                var dict = verse.translations.mapValues { $0 }
                dict["verse"] = "\(verse.number)"
                return dict
            }

            let parseDuration = CFAbsoluteTimeGetCurrent() - parseStartTime
            await MainActor.run {
                self.totalParsingDuration += parseDuration
            }

            return Chapter(id: Int(fileName)!, intro: intro, summary: summary, verses: verses)

        } catch {
            print("Failed to decode Protobuf for file \(fileName): \(error)")
            return nil
        }
    }
}
