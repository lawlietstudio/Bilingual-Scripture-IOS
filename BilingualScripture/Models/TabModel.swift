//
//  TabModel.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-29.
//

import SwiftUI

struct TabModel: Identifiable {
    // Size and the minX properties will be used for dynamic sizing and positioning the indicator in the tab bar
    private(set) var id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    enum Tab: String, CaseIterable {
        case bofm = "Book of Mormon"
        case dc = "Doctrine and Covenants"
        case analytics = "Analytics"
        case audience = "Audience"
        case privacy = "Privacy"
    }
}
