//
//  Common.swift
//  QWUGraphics
//
//  Created by Emilio Espinosa on 5/22/16.
//
//

// QWUColor struct
// Description:
// Responsible for holding the RGBA values of any color to be used in this library.
// Includes some basic preset colors.

public struct QWUColor {
    internal var redVal: Double
    internal var greenVal: Double
    internal var blueVal: Double
    internal var alpha: Double
    
    init(red r: Double, green g: Double, blue b: Double, alpha a: Double = 1.0) {
        redVal = r
        greenVal = g
        blueVal = b
        alpha = a
    }
    
    func getRGBA() -> (Double, Double, Double, Double) {
        return (redVal, greenVal, blueVal, alpha)
    }
    
    static let black = QWUColor(red: 0.0, green: 0.0, blue: 0.0)
    static let darkGray = QWUColor(red: 0.332, green: 0.332, blue: 0.332)
    static let lightGray = QWUColor(red: 0.664, green: 0.664, blue: 0.664)
    static let white = QWUColor(red: 1.0, green: 1.0, blue: 1.0)
    static let red = QWUColor(red: 1.0, green: 0.0, blue: 0.0)
    static let green = QWUColor(red: 0.0, green: 1.0, blue: 0.0)
    static let blue = QWUColor(red: 0.0, green: 0.0, blue: 1.0)
    static let cyan = QWUColor(red: 0.0, green: 1.0, blue: 1.0)
    static let yellow = QWUColor(red: 1.0, green: 1.0, blue: 0.0)
    static let magenta = QWUColor(red: 1.0, green: 0.0, blue: 1.0)
    static let orange = QWUColor(red: 1.0, green: 0.5, blue: 0.0)
    static let purple = QWUColor(red: 0.5, green: 0.0, blue: 0.5)
    static let brown = QWUColor(red: 0.6, green: 0.4, blue: 0.2)
    static let clear = QWUColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
}