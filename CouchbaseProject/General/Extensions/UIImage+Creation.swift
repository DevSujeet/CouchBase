//
//  UIImage+Creation.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 8/28/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit
import SwViewCapture

//extension to get Image from a UIView

// MARK: - <#Description#>
// use:-  pod "SwViewCapture"
//uncomment the method and  import:- func createImageFrom(withScrollView scrollView:UIScrollView) -> UIImage
// set the swift langauge version to 3.2, check pod can be updated
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
    /*
     UIImage* image = nil;
     
     CGPoint savedContentOffset = view.contentOffset;
     CGRect savedFrame = view.frame;
     
     UIGraphicsBeginImageContextWithOptions(view.contentSize, 1, 0);
     view.contentOffset = CGPointZero;
     view.frame = CGRectMake(0, 0, view.contentSize.width, view.contentSize.height);
     
     [view.layer renderInContext: UIGraphicsGetCurrentContext()];
     image = UIGraphicsGetImageFromCurrentImageContext();
     
     view.contentOffset = savedContentOffset;
     view.frame = savedFrame;
     
     UIGraphicsEndImageContext();
     
     // after all of this, crop image to needed size
     return [Utils cropImage:image toRect:rect];
     */
    convenience init(withScrollView scrollView:UIScrollView) {
        let savedContentOffset:CGPoint = scrollView.contentOffset
        let savedFrame = scrollView.frame
        
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, 0)
        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        scrollView.contentOffset =  savedContentOffset
        scrollView.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: (image?.cgImage!)!)
        
    }
    
    convenience init(withTableView tableView:UITableView) {
        let savedContentOffset:CGPoint = tableView.contentOffset
        let savedFrame = tableView.frame
        
        tableView.contentOffset = CGPoint.zero
        tableView.frame = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: tableView.contentSize.height)
//        tableView.reloadData()
        
        //add delay here so that the cell web-chart are drawn.
//        let numbers = 1...900000
//        for i in numbers {
//            print (i)
//        }

        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, 0)

        tableView.drawHierarchy(in: tableView.frame, afterScreenUpdates: true)
        
        
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        tableView.contentOffset =  savedContentOffset
        tableView.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: (image?.cgImage!)!)
        
    }
    
    static func createImageFrom(withScrollView scrollView:UIScrollView) -> UIImage {

        var createImage:UIImage?
        scrollView.swContentScrollCapture {(capturedImage) -> Void in
            // capturedImage is a UIImage.
            createImage = capturedImage
        }
        return createImage!
    }
}
