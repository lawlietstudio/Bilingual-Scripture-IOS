import SwiftUI

struct ChapterView: View {
    var chapter: Chapter  // Assume Chapter struct has necessary details
    var bookTitle: MultilingualText
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            SpeakSection(title: "Intro", multilingualText: chapter.introduction)
            
            if let summary = chapter.summary {
                SpeakSection(title: "Summary", multilingualText: summary)
            }
                
            ForEach(chapter.verses, id: \.key) { verse in
                SpeakSection(title: "Verse \(verse.key)", multilingualText: verse.text)
            }
        }
        .listStyle(.plain)
//        .navigationTitle("\(bookTitle) - 第 \(chapter.number) 章")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("\(bookTitle.en) - Chapter \(chapter.number)")
                        .font(.caption2)
                        .textCase(.uppercase)
                    Text("\(bookTitle.zh) - 第 \(chapter.number) 章")
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
        .onDisappear {
            SpeechUtil.share.stopSpeaking()
        }
    }
}

