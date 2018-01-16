//
//  TitleWithBackView.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/16/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit
protocol TitleWithBackViewDelegate:NSObjectProtocol {
    func didPressedBackButton()
}

class TitleWithBackView: UIView {
    
    weak var delegate:TitleWithBackViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
            titleLabel.textColor = UIColor.lightGray//UIColor(hex6: 0x665978)
        }
    }
    
    @IBOutlet weak var backButton: UIButton!{
        didSet {
            backButton.layer.cornerRadius = 20
            backButton.backgroundColor = UIColor(hex6: 0xE8E8E8)
        }
    }
    
    @IBOutlet weak var sepratorView: UILabel!

    @IBAction func backButtonAction(_ sender: Any) {
        if (delegate != nil) {
            delegate?.didPressedBackButton()
        }
    }
    
    //MARK:- view creation
    class func instanceFromNib() -> TitleWithBackView {
        let headerView = UINib(nibName: "TitleWithBackView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleWithBackView
        return headerView
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)!
        //at this point the view from nib are not initialized.
    }
    
    func setUp(withTitle title:String){
        self.titleLabel.text = title
    }
}
