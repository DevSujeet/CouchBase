//
//  Flashable.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 2/11/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import UIKit

protocol Flashable {
    
}

extension Flashable where Self:UIView {
    
    func flash() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { 
            self.alpha = 1.0
            }) { (animationComplete) in
                if animationComplete == true {
                    //revers the animation
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { 
                        self.alpha = 0.0
                        }, completion: nil)
                }
        }
    }
    
}
