//
//  NSAttributedString+Default.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 7/28/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit

// MARK: - to get an attributted string with given font,color and text.

extension NSAttributedString {
    
    convenience init(text:String, color:UIColor ,font:UIFont) {
        let stringAttributes = [NSAttributedStringKey.foregroundColor:color , NSAttributedStringKey.font: font] as [NSAttributedStringKey : Any]
        self.init(string: text, attributes: stringAttributes)
    }
}
