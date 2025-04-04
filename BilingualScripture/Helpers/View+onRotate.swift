//
//  View+onRotate.swift
//  BilingualScripture
//
//  Created by mark on 2025-04-03.
//

import SwiftUI

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                let orientation = UIDevice.current.orientation
                // only notify view between landscape and Portrait, not flat
                if (orientation.isPortrait || orientation.isLandscape)
                {
                    action(UIDevice.current.orientation)
                }
            }
    }
}
