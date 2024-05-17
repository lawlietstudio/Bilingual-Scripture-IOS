//
//  ChapterSpeakSection.swift
//  BilingualScripture
//
//  Created by Mark Ho on 2024-05-17.
//

import SwiftUI

struct ChapterSpeakSection: View {
    var title: String?
    var multilingualText: MultilingualText
    let languageVisibilities: [LanguageVisibility] = UserDefaults.standard.load()
    
    var body: some View {
        Section(title ?? "") {
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
}
