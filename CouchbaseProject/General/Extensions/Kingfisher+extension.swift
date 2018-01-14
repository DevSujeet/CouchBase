//
//  Kingfisher+extension.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 10/18/16.
//  Copyright © 2016 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

/*
 method to add image on button or image with given image url using
 pod 'Kingfisher'
 */
extension UIButton {
    
    func kf_setImageWithImageURLString(_ urlString:String?,forState: UIControlState, placeholderImage: UIImage?, optionsInfo: KingfisherOptionsInfo?, progressBlock: DownloadProgressBlock?, completionHandler:CompletionHandler?){
        
        var imageURL:URL?
        var urlStringOfImage:String = ""
        if let imageURLString = urlString {
            urlStringOfImage = imageURLString
            imageURL = URL(string: urlStringOfImage)
        }
        
        var cachedImgAsHolderImage:UIImage? = placeholderImage
        
        ImageCache.default.retrieveImage(forKey: urlStringOfImage, options: nil) { (image, cache ) in
            if let image = image {
                cachedImgAsHolderImage = image
            }
            
        }
        
        self.kf.setImage(with:imageURL, for: .normal, placeholder: cachedImgAsHolderImage, options: optionsInfo, progressBlock: nil, completionHandler: nil)
    }
}

extension UIImageView {
    
    func kf_setImageWithImageURLString(_ urlString:String?, placeholderImage: UIImage?, optionsInfo: KingfisherOptionsInfo?, progressBlock: DownloadProgressBlock?, completionHandler:CompletionHandler?){
        
        var imageURL:URL?
        var urlStringOfImage:String = ""
        if let imageURLString = urlString {
            urlStringOfImage = imageURLString
            imageURL = URL(string: urlStringOfImage)
        }
        
        
        var cachedImgAsHolderImage:UIImage? = placeholderImage
        
        ImageCache.default.retrieveImage(forKey: urlStringOfImage, options: nil){ (image, cache ) in
            if let image = image {
                cachedImgAsHolderImage = image
            }
            
        }
        
        self.kf.setImage(with:imageURL, placeholder: cachedImgAsHolderImage, options: optionsInfo, progressBlock: nil, completionHandler: nil)
    }
}
