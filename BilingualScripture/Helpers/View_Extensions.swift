//
//  View_Extensions.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-07.
//

import SwiftUI

/// Custom View Extensions
extension View {
    @ViewBuilder
    func rect(value: @escaping (CGRect) -> ()) -> some View {
        // Returns View's Position in the Screen Coordinate Space
        self.overlay {
            GeometryReader(content: { geometry in
                let rect = geometry.frame(in: .global)
                
                Color.clear
                    .preference(key: RectKey.self, value: rect)
                    .onPreferenceChange(RectKey.self, perform: { rect in
                        value(rect)
                    })
            })
        }
    }
    
    @MainActor
    @ViewBuilder
    func createImages(toggleDarkMode: Bool, currentImage: Binding<UIImage?>, previousImage: Binding<UIImage?>, activeateDarkMode: Binding<Bool>) -> some View {
        self
            .onChange(of: toggleDarkMode) { oldValue, newValue in
                /// So in order to capture the screen, I'm going to find the active key window via UIApplication connectedSessions. Once the window has been found, I will start captureing the views.
                Task {
                    if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {
                        $0.isKeyWindow
                    }) {
                        let imageView = UIImageView()
                        imageView.frame = window.frame
                        imageView.image = window.rootViewController?.view.image(window.frame.size)
                        imageView.contentMode = .scaleAspectFit
                        window.addSubview(imageView)
                        
                        if let rootView = window.rootViewController?.view {
                            let sleepTime = 0.03
                            let frameSize = rootView.frame.size
                            /// Creating Snapshots
                            activeateDarkMode.wrappedValue = !newValue
                            previousImage.wrappedValue = rootView.image(frameSize)
                            try await Task.sleep(for: .seconds(sleepTime))
                            /// New One with Updated Trait State
                            activeateDarkMode.wrappedValue = newValue
                            /// Giving some time to complete the transition
                            try await Task.sleep(for: .seconds(sleepTime))
                            currentImage.wrappedValue = rootView.image(frameSize)
                            /// Removing once all the snapshots has taken
                            try await Task.sleep(for: .seconds(sleepTime))
                            imageView.removeFromSuperview()
                            /// As you can see now, there is no flicking happening. Now let's implement the masking animation with the help of the overlay we built earlier
                        }
                    }
                }
            }
    }
}

/// Converting UIView to UiImage
extension UIView {
    func image(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            drawHierarchy(in: .init(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}
