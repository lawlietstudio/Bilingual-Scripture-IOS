//
//  ChapterTabview.swift
//  BilingualScripture
//
//  Created by mark on 2024-07-16.
//

import SwiftUI
import Combine

struct ChapterTabview: View {
    var chapters: [Chapter]
    var animeBook: AnimeBook
    @State var selectedTab = 1
    @StateObject var chapterTabViewModel: ChapterTabViewModel = ChapterTabViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(chapters) { chapter in
//                Text("\(index)")
                ChapterView(chapter: chapter, currentSpeakingVerse: $chapterTabViewModel.currentSpeakingVerse, selectedTab: $selectedTab)
                    .tabItem {
                        Text("\(chapter.number)")
                    }
                    .tag(chapter.number)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("\(animeBook.engTitle) - \(selectedTab)")
                        .font(.caption2)
                        .textCase(.uppercase)
                    Text("\(animeBook.zhoTitle) - \(selectedTab)")
                        .font(.caption2)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if chapterTabViewModel.isSpeaking {
                    Button(action: {
                        SingleSpeechUtil.share.stopSpeaking()
                    }) {
                        Image(systemName: "stop.circle")
                    }
                }
                else {
                    Menu {
                        ForEach(chapterTabViewModel.languageVisibilities) { visibility in
                            if visibility.isShow {
                                Button(action: {
                                    let chapter = chapters[selectedTab - 1]
                                    let verses = chapter.verses.map {
                                        switch visibility.speechLang {
                                        case .en:
                                            return $0.text.en
                                        case .fr:
                                            return $0.text.fr
                                        case .jp:
                                            return $0.text.jp
                                        case .kr:
                                            return $0.text.kr
                                        case .zh:
                                            return $0.text.zh
                                        }
                                    }
                                    chapterTabViewModel.currentSpeakingVerse = 1
                                    ChapterSpeechUtil.shared.speakVerses(verses: verses, speechLang: visibility.speechLang, newDelegate: chapterTabViewModel)
                                }) {
                                    HStack {
                                        Text(visibility.speechLang.rawValue)
                                        Image(systemName: "play.circle")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
        }
        .animation(.spring, value: chapterTabViewModel.isSpeaking)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Optional: if you want a page style
    }
}

class ChapterTabViewModel : ObservableObject, SpeechUtilDelegate
{
    @Published var isSpeaking: Bool = false
    @Published var languageVisibilities: [LanguageVisibility] = UserDefaults.standard.load()
    @Published var currentSpeakingVerse: Int = 0
    private var cancellables: AnyCancellable?
    
    init() {
        bindUserDefaults()
    }
    
    private func bindUserDefaults() {
        cancellables = NotificationCenter.default.publisher(for: .itemsDataDidChange)
            .receive(on: RunLoop.main)
            .sink { _ in
                self.languageVisibilities = UserDefaults.standard.load()
            }
    }
    
    func didStartSpeaking() {
        isSpeaking = true
    }
    
    func didStopSpeaking() {
        isSpeaking = false
    }
    
    func didFinishSpeaking() {
        currentSpeakingVerse += 1
        isSpeaking = false
    }
}
