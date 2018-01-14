//
//  PaddedLabel.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 5/12/16.
//  Copyright © 2016 Fractal Analytics Inc. All rights reserved.
//

import UIKit

/// A custom label to draw show that it draws itself with a given padding.
class PaddedLabel: UILabel {
    
    ///value of the padding that will be used.
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }

}
