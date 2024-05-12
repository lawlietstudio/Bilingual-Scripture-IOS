//
//  AnimatedTab.swift
//  BilingualScripture
//
//  Created by mark on 2024-05-12.
//

import SwiftUI


enum Tab: String, CaseIterable {
    case scripture = "books.vertical"
    case setting = "gearshape"
    
    var title: String {
        switch self {
        case .scripture:
            return "Scripture"
        case .setting:
            return "Setting"
        }
    }
}

/// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}
