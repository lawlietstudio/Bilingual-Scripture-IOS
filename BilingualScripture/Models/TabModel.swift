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
        case pgp = "Pearl of Great Price"
        case ot = "Old Testament"
        case nt = "New Testament"
        
        var short: String {
            switch self {
            case .bofm:
                return "bofm"
            case .dc:
                return "dc-testament"
            case .pgp:
                return "pgp"
            case .ot:
                return "ot"
            case .nt:
                return "nt"
            }
        }
        
        func title(using languageViewModel: LanguagesViewModel) -> String {
            switch self {
            case .bofm:
                return languageViewModel.localized("book_tab_bofm")
            case .dc:
                return languageViewModel.localized("book_tab_dc")
            case .pgp:
                return languageViewModel.localized("book_tab_pgp")
            case .ot:
                return languageViewModel.localized("book_tab_ot")
            case .nt:
                return languageViewModel.localized("book_tab_nt")
            }
        }
    }
}
