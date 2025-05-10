//
//  ChapterSpeakSection.swift
//  BilingualScripture
//
//  Created by Mark Ho on 2024-05-17.
//

import SwiftUI
import Combine

struct ChapterSpeakSection: View {
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    
    var title: String?
    var multilingualText: MultilingualText

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .textCase(.uppercase)
                    .padding(.horizontal)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                let font: Font = UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline
                
                let primarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.primaryLanguage)
                let secondarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.secondaryLanguage)
                
                SpeakButton(text: multilingualText.getText(lang: primarySpeechLang), speechLang: primarySpeechLang, font: font)
                
                Divider()
                
                SpeakButton(text: multilingualText.getText(lang: secondarySpeechLang), speechLang: secondarySpeechLang, font: font)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}
