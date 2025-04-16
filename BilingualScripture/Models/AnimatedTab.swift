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
    
    var title: String {
        switch self {
        case .scripture:
            return "Scripture"
        case .settings:
            return "Settings"
        }
    }
}
