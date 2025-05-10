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
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    @EnvironmentObject var speechViewModel: SpeechViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(chapters) { chapter in
//                Text("\(index)")
                ChapterView(chapter: chapter, selectedTab: $selectedTab)
                    .tabItem {
                        Text("\(chapter.number)")
                    }
                    .tag(chapter.number)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("\(languagesViewModel.localized(animeBook.localizedBookName)) - \(selectedTab)")
                        .font(.caption2)
                    
                    Text("\(languagesViewModel.localized(animeBook.localizedBookName, isSecondary: true)) - \(selectedTab)")
                        .font(.caption2)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if let _ = speechViewModel.currentSpeakingText {
                    Button(action: {
                        if speechViewModel.isPaused {
                            speechViewModel.resumeSpeaking()
                        } else {
                            speechViewModel.pauseSpeaking()
                        }
                    }) {
                        Image(systemName: speechViewModel.isPaused ? "play.circle" : "pause.circle")
                    }

                    Button(action: {
                        speechViewModel.stopSpeaking()
                    }) {
                        Image(systemName: "stop.circle")
                    }
                } else {
                    Menu {
                        buildSpeakVersesButton(localization: languagesViewModel.primaryLanguage)
                        
                        buildSpeakVersesButton(localization: languagesViewModel.secondaryLanguage)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
        }
        .animation(.spring, value: speechViewModel.currentSpeakingText)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Optional: if you want a page style
    }
    
    @ViewBuilder
    func buildSpeakVersesButton(localization: String) -> some View {
        let speechLang = SpeechLang.speechLang(for: localization)
        let chapter = chapters[selectedTab - 1]
        let verses = chapter.verses.map {
            $0.text.getText(lang: speechLang)
        }
        
        Button(action: {
            speechViewModel.speakVerses(verses: verses, speechLang: speechLang)
        }) {
            HStack {
                Text(languagesViewModel.displayName(for: localization))
                Image(systemName: "play.circle")
            }
        }
    }
}
