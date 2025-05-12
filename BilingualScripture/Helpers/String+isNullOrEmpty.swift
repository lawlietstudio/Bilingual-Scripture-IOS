//
//  String+isNullOrEmpty.swift
//  BilingualScripture
//
//  Created by mark on 2025-05-11.
//

import SwiftUI

extension Optional where Wrapped == String {
    var isNullOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
