//
//  BaseAskViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit
/*
    a controller with a given data source and a ask view with its own data source
 */
struct BaseAskViewControllerSetting {
    static let askViewTopConstraintTopMargin = CGFloat(30)
    static let askViewBottomConstraintFromTopMargin = CGFloat(90)
    static let askViewBorderColor = UIColor(hex6: 0xE8E8E8)
}
class BaseAskViewController: CBLTableViewController {
    
    var askView:AskView!
    
    ///----------for test purpose------
    //each subclass should define its own data array and data source depending upon the requirement.
    let arrayData = ["AAA","BBB","CCC","DDD"]
    var arrayDataSource:ArrayDataSource?
    //----------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view, typically from a nib.
        arrayDataSource = ArrayDataSource(tableView: tableView, array: arrayData)
        
        //similarly other block can be defined for action in cell like edit on cell
        arrayDataSource?.tableItemSelectionHandler = { index in
            print("BaseAskViewController cell selected")
        }
        //1. create ASKView
        createAskViewAndSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createAskViewAndSetup() {
        askView = AskView.instanceFromNib()
        askView.setup()
        
        askView.delegate = self
        askView.layer.cornerRadius = 8
        askView.layer.borderWidth = 1
        askView.layer.borderColor = BaseAskViewControllerSetting.askViewBorderColor.cgColor
        askView.clipsToBounds = true
        self.view.addSubview(askView)
        
        setUpConstraintsForAskView()
    }

    var askTopConstraint:NSLayoutConstraint!
    private func setUpConstraintsForAskView(){
        askView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
        askView.translatesAutoresizingMaskIntoConstraints = false
        
        //setup Constriaint
        let guide = self.view.safeAreaLayoutGuide
        askTopConstraint = (askView.topAnchor.constraint(equalTo: guide.topAnchor))
        askTopConstraint.constant = UIScreen.main.bounds.height - BaseAskViewControllerSetting.askViewBottomConstraintFromTopMargin
        self.view.addConstraint(askTopConstraint)
        let superview = self.view
        //adding height constraint
        superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]", options: [], metrics:["height":superview!.frame.height - BaseAskViewControllerSetting.askViewTopConstraintTopMargin], views: ["view":askView]) )
        
        //Adding side margin constriant
        superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: [], metrics: nil, views: ["view":askView]) )
    }
}

extension BaseAskViewController:AskViewDelegate {
    func doneButtonPressed() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.askTopConstraint.constant = UIScreen.main.bounds.height - BaseAskViewControllerSetting.askViewBottomConstraintFromTopMargin
            self?.view.layoutIfNeeded() ?? ()
        })
        
    }
    
    func didBeginAsking() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.askTopConstraint.constant = BaseAskViewControllerSetting.askViewTopConstraintTopMargin
            self?.view.layoutIfNeeded() ?? ()
        })
    }
}
