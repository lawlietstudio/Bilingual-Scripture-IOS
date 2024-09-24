import SwiftUI

struct ChapterView: View {
    var chapter: Chapter  // Assume Chapter struct has necessary details
    var animeBook: AnimeBook
    @Binding var currentSpeakingVerse: Int
    
    @Environment(\.presentationMode) var presentationMode

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
                withAnimation {
                    proxy.scrollTo("\(newValue)", anchor: .center)
                }
            })
        }
        .safeAreaPadding(.bottom, 16)
        .onDisappear {
            SingleSpeechUtil.share.stopSpeaking()
        }
    }
}

