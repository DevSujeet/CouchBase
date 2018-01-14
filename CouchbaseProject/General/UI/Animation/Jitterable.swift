//
//  Jitterable.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 2/11/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import UIKit

protocol Jitterable {
    
}

extension Jitterable where Self:UIView {
    
    func jitter() {
        print("inside jitter")
        let animationKey = "position"
        let animation = CABasicAnimation(keyPath: animationKey)
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 1, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 1, y: self.center.y))
        layer.add(animation, forKey: animationKey)
    }
}
