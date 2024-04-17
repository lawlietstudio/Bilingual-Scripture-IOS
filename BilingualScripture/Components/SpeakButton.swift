//
//  SpeakButton.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-02.
//

import SwiftUI

struct SpeakButton: View {
    let text: String
    let speechLang: SpeechLang
    var font: Font = .subheadline
    
    var body: some View {
        Button(action: {
            SpeechUtil.share.speak(text: text, speechLang: speechLang)
        }) {
            VStack(alignment: .leading) {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .font(font)
            }
        }
        .buttonStyle(.plain)
    }
}
