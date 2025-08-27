//
//  SpeechLang.swift
//  BilingualScripture
//
//  Created by mark on 2025-05-11.
//

import SwiftUI
import AVFoundation

enum SpeechLang: String, Codable, CaseIterable {
    case fr = "fr-CA"
    case en = "en-US"
    case zh_Hans = "zh-CN"
    case zh_Hant = "zh-TW"
    case jp = "ja-JP"
    case kr = "ko-KR"
    case es = "es-ES"
    
    private var languagePrefixes: [String] {
        let base = rawValue.split(separator: "-").first.map(String.init) ?? rawValue
        switch self {
        case .zh_Hans, .zh_Hant: return ["zh", "yue"]
        default: return [base]
        }
    }

    func getAvailableVoices(allVoices: [AVSpeechSynthesisVoice]) -> [AVSpeechSynthesisVoice] {
        allVoices.filter { v in
            languagePrefixes.contains { v.language.hasPrefix($0) }
        }
    }

    var userDefaultsKey: String {
        "\(self.rawValue)\(LanguagesViewModel.voiceIdentifierKey)"
    }

    var preferredVoiceMatches: [(language: String, name: String?)] {
        switch self {
        case .fr: return [("fr-CA", "Samantha"), ("fr-CA", nil), ("fr-FR", nil)]
        case .en: return [("en-US", "Samantha"), ("en-US", nil)]
        case .zh_Hans: return [("zh-CN", nil)]
        case .zh_Hant: return [("zh-HK", "Sinji"), ("zh-HK", nil)]
        case .jp: return [("ja-JP", nil)]
        case .kr: return [("ko-KR", nil)]
        case .es: return [("es-ES", nil)]
        }
    }
    
    var textLang: String {
        switch self {
        case .fr:
            return "fra"
        case .en:
            return "eng"
        case .zh_Hans:
            return "zhs"
        case .zh_Hant:
            return "zho"
        case .jp:
            return "jpn"
        case .kr:
            return "kor"
        case .es:
            return "spa"
        }
    }
    
    static func speechLang(for localizationCode: String) -> SpeechLang {
        switch localizationCode {
        case "en": return .en
        case "zh-Hans": return .zh_Hans
        case "zh-Hant": return .zh_Hant
        case "fr": return .fr
        case "ja": return .jp
        case "ko": return .kr
        case "es": return .es
        default: return .en
        }
    }
    
    static func selectionBinding(for speechLang: SpeechLang, languageViewModel: Binding<LanguagesViewModel>) -> Binding<String> {
        Binding<String>(
            get: {
                languageViewModel.wrappedValue.selectedVoiceIdentifiers[speechLang] ?? ""
            },
            set: { newValue in
                languageViewModel.wrappedValue.selectedVoiceIdentifiers[speechLang] = newValue
            }
        )
    }
}
