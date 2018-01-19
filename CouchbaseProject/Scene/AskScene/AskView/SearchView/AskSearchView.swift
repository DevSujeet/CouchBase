//
//  AskSearchView.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit
protocol AskSearchViewDelegate:NSObjectProtocol {
    func didAskQuestion(withText question:String)
    func didBeginAsking()
    func didPressDone()
}
struct AskSearchSetting {
    static let askSearchViewBGColor = UIColor(hex6:0xFBFBFB)
    
    static let searchTextBGColor = UIColor(hex6: 0xE8E8E8)
    static let searchTextPlaceholder = "Have a question?"
    static let searchTextPlaceholderFont = UIFont.systemFont(ofSize: 20, weight: .medium)
    
    static let doneBtnTitle = "Done"
    static let doneButtonTextFont = UIFont.systemFont(ofSize: 20, weight: .regular)
}
class AskSearchView: UIView, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.backgroundColor = AskSearchSetting.searchTextBGColor
            searchTextField.rightViewMode = .always
            let mic = UIImageView(image: UIImage(named: "mic") )
            searchTextField.rightView = mic
            
            let placeHolderText = AskSearchSetting.searchTextPlaceholder
            let placeHolderTextColor = UIColor.lightGray
            let placeHolderTextFont = AskSearchSetting.searchTextPlaceholderFont
            let attributedString = NSAttributedString.init(text: placeHolderText, color: placeHolderTextColor, font: placeHolderTextFont)
            searchTextField.attributedPlaceholder = attributedString
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!{
        didSet {
            doneButton.titleLabel?.text = AskSearchSetting.doneBtnTitle
            doneButton.titleLabel?.font = AskSearchSetting.doneButtonTextFont
        }
    }
    
    @IBOutlet weak var textFieldTraillingSpaceConstraint: NSLayoutConstraint!{
        didSet {
            textFieldTraillingSpaceConstraint.constant = 8
        }
    }
    
    weak var delegate:AskSearchViewDelegate?
    
    //MARK:- view creation
    class func instanceFromNib() -> AskSearchView {
        let askSearchView = UINib(nibName: "AskSearchView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AskSearchView
        return askSearchView
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)!
        self.backgroundColor = AskSearchSetting.askSearchViewBGColor
        //at this point the view from nib are not initialized.
    }
    //MARK:- button Action
    
  
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
        if (delegate != nil) {
            self.delegate?.didPressDone()
        }
    }
    
    //MARK:-UITextFieldDelegate
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //start the ask engine
        if (delegate != nil) {
            delegate?.didAskQuestion(withText: textField.text!)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //change the contraint to revel the done button.
        textFieldTraillingSpaceConstraint.constant = 80
        if (delegate != nil) {
            delegate?.didBeginAsking()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textFieldTraillingSpaceConstraint.constant = 8
    }

}
