//
//  RectKey.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-07.
//

import SwiftUI

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
