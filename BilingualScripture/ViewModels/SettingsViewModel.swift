//
//  SettingsViewModel.swift
//  BilingualScripture
//
//  Created by mark on 2025-04-15.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLdsBooksVisible: Bool {
        didSet {
            defaults.set(isLdsBooksVisible, forKey: isLdsBooksVisibleKey)
        }
    }
    
    @Published var isToggledDarkMode: Bool {
        didSet {
            defaults.set(isToggledDarkMode, forKey: isToggledDarkModeKey)
        }
    }
    
    @Published var isActivatedDarkMode: Bool {
        didSet {
            defaults.set(isActivatedDarkMode, forKey: isActivatedDarkModeKey)
        }
    }
    
    @Published var isVersesBarVisible: Bool {
        didSet {
            defaults.set(isVersesBarVisible, forKey: isVersesBarVisibleKey)
        }
    }
    
    @Published var isVerseHighlighted: Bool {
        didSet {
            defaults.set(isVerseHighlighted, forKey: isVerseHighlightedKey)
        }
    }
    
    @Published var verseHighlightedColor: Color {
        didSet {
            defaults.set(verseHighlightedColor.hexString, forKey: verseHighlightedColorKey)
        }
    }
    
    let defaults = UserDefaults.standard

    // MARK: - Constants
    private let isLdsBooksVisibleKey = "isLdsBooksVisible"
    private let isToggledDarkModeKey = "isToggledDarkMode"
    private let isActivatedDarkModeKey = "isActivatedDarkMode"
    private let isVersesBarVisibleKey = "isVersesBarVisible"
    private let isVerseHighlightedKey = "isVerseHighlighted"
    private let verseHighlightedColorKey = "verseHighlightedColor"

    // MARK: - Init
    init() {
        isLdsBooksVisible = Self.loadBool(forKey: isLdsBooksVisibleKey, default: false)
        let isDarkModeFromOs = UITraitCollection.current.userInterfaceStyle == .dark
        isToggledDarkMode = Self.loadBool(forKey: isToggledDarkModeKey, default: isDarkModeFromOs)
        isActivatedDarkMode = Self.loadBool(forKey: isActivatedDarkModeKey, default: isDarkModeFromOs)
        isVersesBarVisible = Self.loadBool(forKey: isVersesBarVisibleKey, default: true)
        isVerseHighlighted = Self.loadBool(forKey: isVerseHighlightedKey, default: true)
        verseHighlightedColor = Self.loadColor(forKey: verseHighlightedColorKey, default: isDarkModeFromOs ? .yellow : .blue)
    }

    // MARK: - Static Helper
    private static func loadBool(forKey key: String, default defaultValue: Bool) -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: key) != nil {
            return defaults.bool(forKey: key)
        } else {
            defaults.set(defaultValue, forKey: key)
            return defaultValue
        }
    }

    private static func loadString(forKey key: String, default defaultValue: String) -> String {
        let defaults = UserDefaults.standard
        if let value = defaults.string(forKey: key) {
            return value
        } else {
            defaults.set(defaultValue, forKey: key)
            return defaultValue
        }
    }
    
    private static func loadColor(forKey key: String, default defaultValue: Color) -> Color {
        let defaults = UserDefaults.standard
        if let value = defaults.string(forKey: key) {
            return Color(hex: value)
        } else {
            defaults.set(defaultValue.hexString, forKey: key)
            return defaultValue
        }
    }
}
