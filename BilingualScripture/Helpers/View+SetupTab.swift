//
//  View+SetupTab.swift
//  BilingualScripture
//
//  Created by mark on 2024-05-12.
//

import SwiftUI

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .tabBar)
    }
}
