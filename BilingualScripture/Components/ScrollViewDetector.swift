//
//  ScrollViewDetector.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-03.
//

import SwiftUI

/// ScrollView Detector
/*
    This will extract UIScrollView from the SwiftUI ScrollView and allow to add carousel capability
 */
struct ScrollViewDetector: UIViewRepresentable {
    @Binding var carouselMode: Bool
    var totalCardCount: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            /*
                Backgroud View
                .backgroud {} Wrapper
                VStack View
                UIScroll Voew
             */
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView
            {
//                print("ScrollView Found")
                scrollView.decelerationRate = carouselMode ? .fast : .normal
                if carouselMode
                {
                    scrollView.delegate = context.coordinator
                }
                else
                {
                    scrollView.delegate = nil
                }
                /// Updateing Total Count in real time
                context.coordinator.totalCount = totalCardCount
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        /// manually updaing the total count from the updatedUIView method to support state changes
        var parent: ScrollViewDetector
        var totalCount: Int = 0
        var velocityY: CGFloat = 0
        
        init(parent: ScrollViewDetector) {
            self.parent = parent
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            /// Removing Invalid Scroll Position's
            let cardHeight: CGFloat = BooksView.cardHeight
            /// Since each card has a spacing, we need to add that to the content offset
            let cardSpacing: CGFloat = 35
            /// Adding velocity fpr more natural feel
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocity.y * 60)
            let index = (targetEnd / cardHeight).rounded()
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            targetContentOffset.pointee.y = modifiedEnd + spacing
            velocityY = velocity.y
        }
        
        /// You can notice that there is some glitch in the scroll animation. That's happening because sometimes scrollview can decelerate that it's ending, so we need to address that too.
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            /// Removing Invalid Scroll Position's
            let cardHeight: CGFloat = BooksView.cardHeight
            /// Since each card has a spacing, we need to add that to the content offset
            let cardSpacing: CGFloat = 35
            /// Adding velocity fpr more natural feel
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocityY * 60)
            /// Limiting its index range from 0 to the last card index.
            let index = max(min((targetEnd / cardHeight).rounded(), CGFloat(totalCount - 1)), 0)
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            scrollView.setContentOffset(.init(x: 0, y: modifiedEnd + spacing), animated: true)
        }
    }
}
