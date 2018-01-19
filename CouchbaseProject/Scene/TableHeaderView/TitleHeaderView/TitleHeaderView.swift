//
//  TitleHeaderView.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

protocol TitleHeaderViewDelegate:NSObjectProtocol {
    func didPressAlertIcon()
    func didPressProfileIcon()
}
struct TitleHeaderSetting {
    static let titleLabelTextColor = UIColor(hex6: 0x665978)
    static let dateLabelTextColor = UIColor(hex6: 0xDEDEDE)
    static let separatorLabelColor = UIColor(hex6: 0xE8E8E8)
    
    static let alertButtonBgColor = UIColor(hex6: 0xE8E8E8)
    static let alertButtonImageName = "notification-icon-dark"
    static let buttonWidth  = CGFloat(44)
}
class TitleHeaderView: UIView {

    weak var delegate:TitleHeaderViewDelegate?
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
            titleLabel.textColor = TitleHeaderSetting.titleLabelTextColor
        }
    }
    
    @IBOutlet weak var datelabel: UILabel!{
        didSet{
            datelabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            datelabel.textColor = TitleHeaderSetting.dateLabelTextColor
        }
    }
    
    @IBOutlet weak var separatorLabel: UILabel!{
        didSet{
            separatorLabel.backgroundColor = TitleHeaderSetting.separatorLabelColor
        }
    }
    
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint! {
        didSet{
            buttonWidthConstraint.constant = TitleHeaderSetting.buttonWidth
        }
    }
    
    @IBOutlet weak var alertButton: UIButton!{
        didSet{
            alertButton.layer.cornerRadius = TitleHeaderSetting.buttonWidth * 0.5
            alertButton.backgroundColor = TitleHeaderSetting.alertButtonBgColor
            alertButton.setImage(UIImage(named:TitleHeaderSetting.alertButtonImageName), for: .normal)
            alertButton.dropShadow()
        }
    }
    
    @IBOutlet weak var profileButton: UIButton!{
        didSet{
            profileButton.layer.cornerRadius = TitleHeaderSetting.buttonWidth * 0.5
            profileButton.backgroundColor = UIColor(hex6: 0xE8E8E8)
            profileButton.dropShadow()
        }
    }
    
    @IBAction func alertButtonAction(_ sender: UIButton) {
        if (delegate !=  nil) {
            delegate?.didPressAlertIcon()
        }
    }
    @IBAction func profileButtonAction(_ sender: UIButton) {
        if (delegate !=  nil) {
            delegate?.didPressProfileIcon()
        }
    }
    
    //MARK:- view creation
    class func instanceFromNib() -> TitleHeaderView {
        let headerView = UINib(nibName: "TitleHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleHeaderView
        return headerView
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)!
        //at this point the view from nib are not initialized.
    }
    
    //Mark:- set title and date
    func setUp(with title:String, date:String?) {
        
        self.titleLabel.text = title
        if (date != nil){
            self.datelabel.text = date
        }else{
            let currentDate = Date()
            let currentDateString = Utility.dateToString(format: "EEEE,dd MMM", date: currentDate)
            self.datelabel.text = currentDateString
        }
    }
}
