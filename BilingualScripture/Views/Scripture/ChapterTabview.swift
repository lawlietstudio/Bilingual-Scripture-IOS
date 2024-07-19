//
//  ChapterTabview.swift
//  BilingualScripture
//
//  Created by mark on 2024-07-16.
//

import SwiftUI

struct ChapterTabview: View {
    var chapters: [Chapter]
    var animeBook: AnimeBook
    @State var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(chapters) { chapter in
//                Text("\(index)")
                ChapterView(chapter: chapter, animeBook: animeBook)
                    .tabItem {
                        Text("\(chapter.number)")
                    }
                    .tag(chapter.number)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("\(animeBook.engTitle) - Chapter \(selectedTab)")
                        .font(.caption2)
                        .textCase(.uppercase)
                    Text("\(animeBook.zhoTitle) - 第 \(selectedTab) 章")
                        .font(.caption2)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    SpeechUtil.share.stopSpeaking()
                }) {
                    Image(systemName: "stop.circle")
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Optional: if you want a page style
    }
}
