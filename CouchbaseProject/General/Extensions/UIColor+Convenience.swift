//
//  UIColor+Convenience.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 2/17/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    /**
     The shorthand three-digit hexadecimal representation of color.
     #RGB defines to the color #RRGGBB.
     
     - parameter hex3: Three-digit hexadecimal value.
     - parameter alpha: 0.0 - 1.0. The default is 1.0.
     */
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The shorthand four-digit hexadecimal representation of color with alpha.
     #RGBA defines to the color #RRGGBBAA.
     
     - parameter hex4: Four-digit hexadecimal value.
     */
    public convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     
     - parameter hex6: Six-digit hexadecimal value.
     */
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-charater String representation of color of the form RRGGBB.
     
     - parameter String6: Six-charater string value.
     */
    public convenience init(string6:String, alpha: CGFloat = 1){
        
        let divisor = CGFloat(255)
        let chars = Array(string6.characters)
        
        let numbers = stride(from: 0, to: chars.count, by: 2).map {
            UInt32(String(chars[$0 ..< $0+2]), radix: 16) ?? 0
        }
        let red = CGFloat(numbers[0]) / divisor
        let green = CGFloat(numbers[1]) / divisor
        let blue = CGFloat(numbers[2]) / divisor
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    
    var lighterColor: UIColor {
        return lighterColor(removeSaturation: 0.4, resultAlpha: 1)
    }
    
    /**
     Get lighter color by playing with the saturation and brightness value.
     Basically Brightness (Value) makes the color less or more closer to black, where Saturation makes it less or more closer to white
     
     - parameter removeSaturation: staturation value 0 to 1.
     - parameter resultAlpha: alpha value as required..
     */
    func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}
        
        return UIColor(hue: h,
                       saturation: max(s - val, 0.0),
                       brightness: b,
                       alpha: alpha == -1 ? a : alpha)
    }
    
    /**
     Get lighter color by shifting the RGB value towards white(#FFFFFF).
     by shifting towards white..moving towards brighter color
     
     - parameter percentage: percentage shift in each RGB value.
     */
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    /**
     Get lighter color by shifting the RGB value towards black(#000000).
     by shifting towards Black..moving towards darker color
     
     - parameter percentage: percentage shift in each RGB value.
     */
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
   func toHexString() -> String {
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0
            
            getRed(&r, green: &g, blue: &b, alpha: &a)
            
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            
            return String(format:"#%06x", rgb)
    }
}

