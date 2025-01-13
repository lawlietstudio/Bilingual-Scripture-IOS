import SwiftUI
import Combine

struct ChapterView: View {
    var chapter: Chapter  // Assume Chapter struct has necessary details
    @Binding var currentSpeakingVerse: Int
    @Binding var selectedTab: Int
    @StateObject var chapterViewModel: ChapterViewModel = ChapterViewModel()

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ChapterSpeakSection(title: "Intro", multilingualText: chapter.introduction)
                
                if let summary = chapter.summary {
                    ChapterSpeakSection(title: "Summary", multilingualText: summary)
                }
                
                ForEach(chapter.verses, id: \.key) { verse in
                    ChapterSpeakSection(title: "Verse \(verse.key)", multilingualText: verse.text)
                        .id(verse.key)
                }
            }
            .onChange(of: currentSpeakingVerse, { oldValue, newValue in
                if selectedTab == chapter.number {
                    withAnimation {
                        proxy.scrollTo("\(newValue)", anchor: .center)
                    }
                }
            })
            .safeAreaPadding(.trailing, chapterViewModel.isShowVersesBar ? 16 : 0)
            .overlay(alignment: .trailing) {
                if chapterViewModel.isShowVersesBar {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center, spacing: 8) {
                            ForEach(chapter.verses, id: \.key) { verse in
                                Button {
                                    withAnimation {
                                        proxy.scrollTo(verse.key, anchor: .center)
                                    }
                                } label: {
                                    Text("\(verse.key)")
                                        .font(.subheadline)
                                }
                                
                            }
                        }
                    }
                    .safeAreaPadding(.top, 8)
                    .frame(width: 32)
                    .background(.listBackground)
                }
            }
        }
        .safeAreaPadding(.bottom, 16)
        .onDisappear {
            SingleSpeechUtil.share.stopSpeaking()
        }
    }
}

class ChapterViewModel : ObservableObject
{
    var cancellables: AnyCancellable?
    @AppStorage("isShowVersesBar") var isShowVersesBar: Bool = false
    
    init() {
        cancellables = NotificationCenter.default.publisher(for: .isShowVersesBarDidChange)
            .receive(on: RunLoop.main)
            .sink { [self] notification in
                if let isShow = notification.object as? Bool {
                    isShowVersesBar = isShow
                }
            }
    }
}
