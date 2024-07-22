import SwiftUI

struct ChapterView: View {
    var chapter: Chapter  // Assume Chapter struct has necessary details
    var animeBook: AnimeBook
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            ChapterSpeakSection(title: "Intro", multilingualText: chapter.introduction)
            
            if let summary = chapter.summary {
                ChapterSpeakSection(title: "Summary", multilingualText: summary)
            }
                
            ForEach(chapter.verses, id: \.key) { verse in
                ChapterSpeakSection(title: "Verse \(verse.key)", multilingualText: verse.text)
            }
        }
        .safeAreaPadding(.bottom, 16)
        .onDisappear {
            SpeechUtil.share.stopSpeaking()
        }
    }
}

