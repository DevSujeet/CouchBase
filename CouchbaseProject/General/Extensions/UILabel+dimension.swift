//
//  UILabel+dimension.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 3/4/16.
//  Copyright © 2016 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit

///extension for label to calculate its required height or width
extension UILabel {
    
    /**
    calculates the height of the label for a given width.
    
     - Author:
        Cuddle.inc
     
     - returns:
        height of the label.
     
     - parameters:
        - text: text for the label.
        - font: font of the label.
        - width: allowed width for the label.
     - Important:
        text should not be nil or empty string else will return 0 value.
     
     - Version:
        1.2.2
     */
    class func heightForLabel(labelText text:String?, font:UIFont, width:CGFloat,numberLines:Int = 0) -> CGFloat {
        if text != nil && text != "" {
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = numberLines
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = text
            
            label.sizeToFit()
            let size = label.sizeThatFits(CGSize(width: width, height: label.frame.height))
            return size.height//label.frame.height
        } else {
            return 0
        }

    }

    /**
     calculates the width of the label for a given height.
     
     - Author:
     Cuddle.inc
     
     - returns:
     height of the label.
     
     - parameters:
     - text: text for the label.
     - font: font of the label.
     - width: allowed width for the label.
     - Important:
     text should not be nil or empty string else will return 0 value.
     
     - Version:
     1.2.2
     */
    class func widthForLabel(labelText text:String, font:UIFont, height:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.width
    }

}


extension UIFont {
    
    func withTraits(_ size:CGFloat, traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: size)
    }
    
    func boldItalic(_ size:CGFloat) -> UIFont {
        return withTraits(size, traits: .traitBold, .traitItalic)
    }
    
    func boldFont(_ size:CGFloat) -> UIFont {
        return withTraits(size, traits: .traitBold)
    }
}
