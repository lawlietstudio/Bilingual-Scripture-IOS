//
//  LanguagesViewModel.swift
//  BilingualScripture
//
//  Created by mark on 2025-04-22.
//

import SwiftUI
import AVFoundation

class LanguagesViewModel: ObservableObject {
    public lazy var allVoices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices()
    
    @Published var primaryLanguage: String {
        didSet {
            UserDefaults.standard.set(primaryLanguage, forKey: primaryLanguageKey)
        }
    }

    @Published var secondaryLanguage: String {
        didSet {
            UserDefaults.standard.set(secondaryLanguage, forKey: secondaryLanguageKey)
        }
    }
    
    @Published var selectedVoiceIdentifiers: [SpeechLang: String] {
        didSet {
            for (lang, identifier) in selectedVoiceIdentifiers {
                let key = "\(lang.rawValue)\(LanguagesViewModel.voiceIdentifierKey)"
                UserDefaults.standard.set(identifier, forKey: key)
            }
        }
    }
    
    private let primaryLanguageKey = "primaryLanguage"
    private let secondaryLanguageKey = "secondaryLanguage"
    
    public static let voiceIdentifierKey = "voiceIdentifier"

    init() {
        var primaryLang = "en"
        if let systemLang = Locale.preferredLanguages.first {
            if let localization = Bundle.main.localizations.first(where: { $0 == systemLang }) {
                primaryLang = localization
            }
        }
        primaryLanguage = SettingsViewModel.loadString(forKey: primaryLanguageKey, default: primaryLang)
        
        let secondLang = primaryLang != "en" ? "en" : "zh-Hant"
        secondaryLanguage = SettingsViewModel.loadString(forKey: secondaryLanguageKey, default: secondLang)
        
        // voices
        selectedVoiceIdentifiers = Dictionary(uniqueKeysWithValues: SpeechLang.allCases.map { lang in
            let defaultVoiceID = AVSpeechSynthesisVoice(language: lang.rawValue)?.identifier ?? ""
            let voiceID = SettingsViewModel.loadString(forKey: lang.userDefaultsKey, default: defaultVoiceID)

            return (lang, voiceID)
        })
    }

    func localized(_ key: String, tableName: String? = nil, isSecondary: Bool = false) -> String {
        guard let path = Bundle.main.path(forResource: isSecondary ? secondaryLanguage : primaryLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return key
        }
        return NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: "")
    }

    var supportedLanguages: [String] {
        Bundle.main.localizations.filter { $0 != "Base" }.sorted { displayName(for: $0) < displayName(for: $1) }
    }

    func displayName(for languageCode: String) -> String {
        let locale = Locale(identifier: languageCode)
        return locale.localizedString(forIdentifier: languageCode) ?? languageCode
    }
}
