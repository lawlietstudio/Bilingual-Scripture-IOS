//
//  TabShape.swift
//  BilingualScripture
//
//  Created by Mark Ho on 2024-05-17.
//

import SwiftUI

struct TabShape: Shape {
    let variant: CGFloat = 25
    var midpoint: CGFloat
    
    var animatableData: CGFloat {
        get { midpoint }
        set {
            midpoint = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            /// First drawing the Rectangle Shape
            path.addPath(Rectangle().path(in: rect))
            /// Now Drawing Upward Curve Shape
            path.move(to: .init(x: midpoint - 60, y: 0))
            
            let to = CGPoint(x: midpoint, y: -variant)
            let control1 = CGPoint(x: midpoint - variant, y: 0)
            let control2 = CGPoint(x: midpoint - variant, y: -variant)
            
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: midpoint + 60, y: 0)
            let control3 = CGPoint(x: midpoint + variant, y: -variant)
            let control4 = CGPoint(x: midpoint + variant, y: 0)
            
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}
