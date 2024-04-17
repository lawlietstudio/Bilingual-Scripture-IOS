import SwiftUI

struct ChapterView: View {
    var chapter: Chapter  // Assume Chapter struct has necessary details
    var bookTitle: MultilingualText
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            Text("Intro")
                .foregroundStyle(.gray)
                .font(.caption2)
                .textCase(.uppercase)
            
            SpeakButton(text: chapter.introduction.en, speechLang: .en)
                
            SpeakButton(text: chapter.introduction.zh, speechLang: .zh)
                
            ForEach(chapter.verses, id: \.key) { verse in
                Text("Verse \(verse.key)")
                    .foregroundStyle(.gray)
                    .font(.caption2)
                    .textCase(.uppercase)
                    
                SpeakButton(text: verse.text.en, speechLang: .en)
                
                SpeakButton(text: verse.text.zh, speechLang: .zh)
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

