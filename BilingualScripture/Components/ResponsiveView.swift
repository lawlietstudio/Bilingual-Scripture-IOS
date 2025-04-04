//
//  ResponsiveView.swift
//  BilingualScripture
//
//  Created by mark on 2025-04-02.
//

import SwiftUI

// MARK: CustomView which will give useful properties for adaptable UI
struct ResponsiveView<Content: View>: View {
    var content: (Properties)->Content
    
    init(@ViewBuilder content: @escaping (Properties)->Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isLandscape = size.width > size.height
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            
            let isMaxSplit = isSplit() && size.width < 400
            
            // MARK: In Vertical Hiding Side Bar Comletely
            // In Horizontal Showing Side bar for 0.75 Fraction
            let isAdoptable = isIpad && (isLandscape ? !isMaxSplit : !isSplit())
            let properties = Properties(isLandscape: isLandscape, isIPad: isIpad, isSplit: isSplit(), isMaxSplit: isMaxSplit, isAdoptable: isAdoptable, size: size)
            content(properties)
                .frame(width: size.width, height: size.height)
        }
    }
    
    // MARK: Simple way to find it the app is in Split View
    func isSplit()->Bool {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
        return screen.windows.first?.frame.size != screen.screen.bounds.size
    }
}

struct Properties {
    var isLandscape: Bool
    var isIPad: Bool
    var isSplit: Bool
    // MARK: If the App size is reduced more than 1/3 in split mode on iPad
    var isMaxSplit: Bool
    var isAdoptable: Bool
    var size: CGSize
    
    var columnCount: Int {
        max(1, Int(floor(size.width / 300)))
    }
    
    var cardHeight: CGFloat {
        let localCardHeight = (size.width - 40) / 9 * 7
        return localCardHeight / CGFloat(columnCount)
    }
}

