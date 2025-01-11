//
//  UIColor+HEX.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//
import UIKit

// MARK: - UIColor extension
extension UIColor {
    // MARK: - Hex letters
    enum hexLetters: String, CaseIterable {
        case A, B, C, D, E, F
        case one = "1", two = "2", three = "3", four = "4", five = "5"
        case six = "6", seven = "7", eight = "8", nine = "9", zero = "0"
    }
    
    // MARK: - Initializer from hex
    convenience init?(hex: String) {
        var newHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        newHex = newHex.uppercased()
        
        if newHex.hasPrefix("#") {
            newHex.removeFirst()
        }
        
        if newHex.count != 6 {
            return nil
        }
        
        var rgb: UInt64 = 0
        
        Scanner(string: newHex).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255
        let green = Double((rgb & 0x00FF00) >> 8) / 255
        let blue = Double(rgb & 0x0000FF) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: - Get Unique Colors
    static func getUniqueColors(_ count: Int) -> [UIColor] {
        var setColors: Set<UIColor> = []
        while setColors.count < count {
            let randomColor = UIColor.random()
            setColors.insert(randomColor)
        }
        return Array(setColors)
    }
    
    // MARK: - Get random color
    static func random() -> UIColor {
        let hex = randomHEXColor()
        return UIColor(hex: hex) ?? UIColor.white
    }
    
    // MARK: - Get random hex color
    static func randomHEXColor() -> String {
        var hex = "#"
        for _ in 0..<6 {
            hex.append(hexLetters.allCases.randomElement()!.rawValue)
        }
        return hex
    }
}

