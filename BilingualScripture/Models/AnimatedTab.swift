//
//  AnimatedTab.swift
//  BilingualScripture
//
//  Created by mark on 2024-05-12.
//

import SwiftUI


enum Tab: String, CaseIterable {
    case scripture = "books.vertical.fill"
    case settings = "gearshape.fill"
    
    func title(using languageViewModel: LanguagesViewModel) -> String {
        switch self {
        case .scripture:
            return languageViewModel.localized("tab_scripture")
        case .settings:
            return languageViewModel.localized("tab_settings")
        }
    }
}
