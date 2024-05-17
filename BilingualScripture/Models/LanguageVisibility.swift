//
//  LanguageVisibility.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-28.
//

import Foundation

struct LanguageVisibility:Identifiable, Codable {
    var id = UUID()
    var speechLang: SpeechLang
    var isShow: Bool = true
}
