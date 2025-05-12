//
//  ChapterTabview.swift
//  BilingualScripture
//
//  Created by mark on 2024-07-16.
//

import SwiftUI
import Combine

struct ChapterTabview: View {
    
    var animeBook: AnimeBook
    var chapters: [Chapter]
//    var chapterNames: [Int] = []
    @State var selectedTab: Int
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    @EnvironmentObject var speechViewModel: SpeechViewModel
    

    
    var body: some View {
        TabView(selection: $selectedTab) {
//            Text("\($chapters.count)")
            ForEach(chapters, id: \.id) { chapter in
//                Text("\(index)")
//                Text("\(chapter.id)")
                ChapterView(chapter: chapter, selectedTab: $selectedTab)
                    .tabItem {
                        Text("\(chapter.id)")
                    }
                    .tag(chapter.id)
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
//        .task {
//            loadAllChapters()
//        }
    }
    
//    func loadAllChapters() {
////        var chapters: [NewChapter] = []
////        chapters.removeAll()
//        for index in chapterNames {
//            if let chapter = loadChapter(fromCSVNamed: "\(index)") {
//                chapters.append(chapter)
//            }
//        }
////        chapters chapters
//    }

    func loadChapter(fromCSVNamed fileName: String) -> Chapter? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "csv", subdirectory: "outputs/\(animeBook.category)/\(animeBook.bookName)") else {
            print("CSV file not found: \(fileName)")
            return nil
        }
        
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }

            // Check for | separator declaration
            var startIndex = 0
            if lines[0].starts(with: "Sep=") {
                startIndex += 1
            }
            
            let header = lines[startIndex].components(separatedBy: "|") // verse, eng, zho, ...
            var summary: [String: String] = [:]
            var verses: [[String: String]] = []
            
            for line in lines.dropFirst(startIndex + 1) {
                let columns = line.components(separatedBy: "|")
                guard columns.count >= 2 else { continue }

                let label = columns[0].lowercased()
                let translations = Dictionary(uniqueKeysWithValues: zip(header.dropFirst(), columns.dropFirst()))

                if label == "summary" {
                    summary = translations
                } else {
                    verses.append(translations)
                }
            }

            return Chapter(id: Int(fileName)!, intro: [:], summary: summary, verses: verses)
            
        } catch {
            print("Failed to read CSV: \(error)")
            return nil
        }
    }

    
    @ViewBuilder
    func buildSpeakVersesButton(localization: String) -> some View {
        let speechLang = SpeechLang.speechLang(for: localization)
        let textLang = speechLang.textLang
        if !chapters.isEmpty {
            let chapter = chapters[selectedTab - 1]
            let verses = chapter.verses.compactMap {
                $0[textLang] ?? nil // an empty string instead of nil, so that the verse number count is correct for scolling
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
}
