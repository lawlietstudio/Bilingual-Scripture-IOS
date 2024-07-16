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
                return "BOFM"
            case .dc:
                return "DC"
            case .pgp:
                return "PGP"
            case .ot:
                return "OT"
            case .nt:
                return "NT"
            }
        }
    }
}
