//
//  ChapterSpeakSection.swift
//  BilingualScripture
//
//  Created by Mark Ho on 2024-05-17.
//

import SwiftUI
import Combine

struct NewChapterSpeakSection: View {
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    
    var title: String?
    var verse: [String: String]

    var body: some View {
        let font: Font = UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline

        let primarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.primaryLanguage)
        let secondarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.secondaryLanguage)

        let verseInPrimaryLang = verse[primarySpeechLang.textLang]
        let verseInSecondaryLang = verse[secondarySpeechLang.textLang]

        if !verseInPrimaryLang.isNullOrEmpty || !verseInSecondaryLang.isNullOrEmpty {
            VStack(alignment: .leading, spacing: 8) {
                if let title {
                    Text(title)
                        .textCase(.uppercase)
                        .padding(.horizontal)
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    if let text = verseInPrimaryLang, !text.isEmpty {
                        SpeakButton(text: text, speechLang: primarySpeechLang, font: font)
                    }

                    if !verseInPrimaryLang.isNullOrEmpty && !verseInSecondaryLang.isNullOrEmpty {
                        Divider()
                    }

                    if let text = verseInSecondaryLang, !text.isEmpty {
                        SpeakButton(text: text, speechLang: secondarySpeechLang, font: font)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }
}
