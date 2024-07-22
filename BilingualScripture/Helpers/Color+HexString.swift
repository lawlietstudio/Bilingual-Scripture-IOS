//
//  Color+HexString.swift
//  BilingualScripture
//
//  Created by mark on 2024-07-20.
//

import SwiftUI

extension Color {
    init(hex: String) {
        // Remove the hash if it exists
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        // Ensure the string is valid
        guard hex.count == 6 else {
            self.init(.gray) // Fallback color in case of invalid input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    var hexString: String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "#000000" // Default to black if conversion fails
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
    }
}
