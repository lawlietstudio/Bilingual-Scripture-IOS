//
//  SpeakSection.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-28.
//

import SwiftUI
import Combine

struct SpeakSection: View {
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    var title: String?
    var themeMultilingualText: MultilingualText
    var introMultilingualText: MultilingualText
    
    var body: some View {
        if let title {
            Text(title)
                .foregroundStyle(.gray)
                .font(.caption2)
                .textCase(.uppercase)
        }
        
        let primarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.primaryLanguage)
        let secondarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.secondaryLanguage)
        
        SpeakButton(text: showThemeOrIntro(theme: themeMultilingualText.getText(lang: primarySpeechLang), intro: introMultilingualText.getText(lang: primarySpeechLang)), speechLang: primarySpeechLang)
        
        SpeakButton(text: showThemeOrIntro(theme: themeMultilingualText.getText(lang: secondarySpeechLang), intro: introMultilingualText.getText(lang: secondarySpeechLang)), speechLang: secondarySpeechLang)
    }
    
    func matchChapter(line: String) -> String? {
        let patterns = [
            "^Chapitre (\\d+)",
            "^CHAPTER (\\d+)",
            "^Chapter (\\d+)",
            "^PSALM (\\d+)",
            "^第(\\d+)篇",
            "^第(\\d+)章",
            "^제 (\\d+) 장",
            "^제 (\\d+) 편"
        ]
        
        for pattern in patterns {
            if let match = line.range(of: pattern, options: .regularExpression) {
                return String(line[match])
            }
        }
        
        return nil
    }
    
    func showThemeOrIntro(theme: String, intro: String) -> String {
        let result = theme.count > intro.count ? theme : intro
        if matchChapter(line: result) != nil {
            return "-"
        }
        else {
            return result
        }
    }
}
