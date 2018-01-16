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

class TitleHeaderView: UIView {

    weak var delegate:TitleHeaderViewDelegate?
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
            titleLabel.textColor = UIColor(hex6: 0x665978)
            titleLabel.backgroundColor = UIColor.yellow
        }
    }
    
    @IBOutlet weak var datelabel: UILabel!{
        didSet{
            datelabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            datelabel.backgroundColor = UIColor.green
        }
    }
    
    @IBOutlet weak var alertButton: UIButton!{
        didSet{
            alertButton.layer.cornerRadius = 20
            alertButton.backgroundColor = UIColor(hex6: 0xE8E8E8)
        }
    }
    
    @IBOutlet weak var profileButton: UIButton!{
        didSet{
            profileButton.layer.cornerRadius = 20
            profileButton.backgroundColor = UIColor(hex6: 0xE8E8E8)
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
