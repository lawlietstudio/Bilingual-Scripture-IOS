//
//  UserDefaults+LangVisibilityStorage.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-28.
//

import Foundation

extension UserDefaults {
    func save(_ items: [LanguageVisibility]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
            NotificationCenter.default.post(name: .itemsDataDidChange, object: nil)
        }
    }
    
    func load() -> [LanguageVisibility] {
        if let savedItems = UserDefaults.standard.data(forKey: "Items"),
           let decodedItems = try? JSONDecoder().decode([LanguageVisibility].self, from: savedItems) {
            return decodedItems
        }
        return [
            LanguageVisibility(speechLang: .fr, isShow: false),
            LanguageVisibility(speechLang: .en),
            LanguageVisibility(speechLang: .zh),
            LanguageVisibility(speechLang: .jp, isShow: false),
            LanguageVisibility(speechLang: .kr, isShow: false)
        ] // default list if nothing is stored
    }
}

extension Notification.Name {
    static let itemsDataDidChange = Notification.Name("itemsDataDidChange")
    static let highlightColorDidChange = Notification.Name("highlightColorDidChange")
}
