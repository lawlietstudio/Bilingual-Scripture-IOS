//
//  SpeakSection.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-28.
//

import SwiftUI

struct SpeakSection: View {
    var title: String?
    var multilingualText: MultilingualText
    let languageVisibilities: [LanguageVisibility] = UserDefaults.standard.load()
    
    var body: some View {
        if let title {
            Text(title)
                .foregroundStyle(.gray)
                .font(.caption2)
                .textCase(.uppercase)
        }
        
        ForEach(languageVisibilities) { visibility in
            if visibility.isShow {
                switch visibility.speechLang {
                case .fr:
                    SpeakButton(text: multilingualText.fr, speechLang: .fr)
                case .en:
                    SpeakButton(text: multilingualText.en, speechLang: .en)
                case .zh:
                    SpeakButton(text: multilingualText.zh, speechLang: .zh)
                }
            }
        }
    }
}
