import SwiftUI
import Combine

struct ChapterView: View {
    var chapter: Chapter  // Assume Chapter struct has necessary details
    @Binding var selectedTab: Int
    @EnvironmentObject var speechViewModel: SpeechViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var languagesViewModel: LanguagesViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 36) {
                    let intro = chapter.intro.compactMapValues { $0 }
                    if !intro.isEmpty {
                        NewChapterSpeakSection(title: languagesViewModel.localized("label.intro"), verse: intro)
                    }
                    
                    let summary = chapter.summary.compactMapValues { $0 }
                    if !summary.isEmpty {
                        NewChapterSpeakSection(title: languagesViewModel.localized("label.summary"), verse: summary)
                    }
                    
                    ForEach(Array(chapter.verses.enumerated()), id: \.offset) { index, verse in
                        let checkedVerse = verse.compactMapValues { $0 }
                        let title = String.init(format: languagesViewModel.localized("label.verse_with_number"), index + 1)
                        NewChapterSpeakSection(title: title, verse: checkedVerse)
                            .id("\(index + 1)")
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color("ListBackgroundColor"))
            }
            .scrollIndicators(.hidden)
            .onChange(of: speechViewModel.speakVersesPackage?.currentParagraphIndex ?? -1, { oldValue, newValue in
                guard newValue >= 0, selectedTab == chapter.id else { return }
                withAnimation {
                    proxy.scrollTo("\(newValue + 1)", anchor: .center)
                }
            })
            .padding(.trailing, settingsViewModel.isVersesBarVisible ? 16 : 0)
            .overlay(alignment: .trailing) {
                if settingsViewModel.isVersesBarVisible {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center, spacing: 8) {
                            ForEach(Array(chapter.verses.enumerated()), id: \.offset) { index, _ in
                                Button {
                                    withAnimation {
                                        proxy.scrollTo(index + 1, anchor: .center)
                                    }
                                } label: {
                                    Text("\(index + 1)")
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
        .background(Color(.systemGroupedBackground))
        .safeAreaPadding(.bottom, 16)
        .onDisappear {
            speechViewModel.stopSpeaking()
        }
    }
}
