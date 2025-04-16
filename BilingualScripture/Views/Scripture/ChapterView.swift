import SwiftUI
import Combine

struct ChapterView: View {
    var chapter: Chapter  // Assume Chapter struct has necessary details
    @Binding var selectedTab: Int
    @EnvironmentObject var speechViewModel: SpeechViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 36) {
                    ChapterSpeakSection(title: "Intro", multilingualText: chapter.introduction)
                    
                    if let summary = chapter.summary {
                        ChapterSpeakSection(title: "Summary", multilingualText: summary)
                    }
                    
                    ForEach(chapter.verses, id: \.key) { verse in
                        ChapterSpeakSection(title: "Verse \(verse.key)", multilingualText: verse.text)
                            .id(verse.key)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color("ListBackgroundColor"))
            }
            .scrollIndicators(.hidden)
            .onChange(of: speechViewModel.speakVersesPackage?.currentParagraphIndex ?? -1, { oldValue, newValue in
                guard newValue >= 0, selectedTab == chapter.number else { return }
                withAnimation {
                    proxy.scrollTo("\(newValue + 1)", anchor: .center)
                }
            })
            .padding(.trailing, settingsViewModel.isVersesBarVisible ? 16 : 0)
            .overlay(alignment: .trailing) {
                if settingsViewModel.isVersesBarVisible {
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
        .background(Color(.systemGroupedBackground))
        .safeAreaPadding(.bottom, 16)
        .onDisappear {
            speechViewModel.stopSpeaking()
        }
    }
}
