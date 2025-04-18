//
//  SpeakButton.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-02.
//

import SwiftUI
import Combine

struct SpeakButton: View {
    let text: String
    let speechLang: SpeechLang
    var font: Font = .subheadline
    @EnvironmentObject var speechViewModel: SpeechViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        Button(action: {
            speechViewModel.speak(text: text, speechLang: speechLang)
        }) {
            VStack(alignment: .leading) {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .font(font)
                    .italic(isHighlighted)
                    .underline(isHighlighted)
                    .foregroundColor(isHighlighted ? settingsViewModel.verseHighlightedColor : .accentColor)
            }
        }
        .buttonStyle(.plain)
    }
    
    var isHighlighted: Bool {
        settingsViewModel.isVerseHighlighted && text == speechViewModel.currentSpeakingText
    }
}
