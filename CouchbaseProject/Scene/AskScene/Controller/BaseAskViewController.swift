//
//  BaseAskViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit
struct BaseAskViewControllerSetting {
    static let askViewTopConstraintTopMargin = CGFloat(70)
}
class BaseAskViewController: CBLTableViewController {
    
    var askView:AskView!
    
    ///----------for test purpose------
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
        askView.layer.cornerRadius = 8
        askView.setupTest()
        askView.delegate = self
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
        askTopConstraint.constant = UIScreen.main.bounds.height - BaseAskViewControllerSetting.askViewTopConstraintTopMargin
        self.view.addConstraint(askTopConstraint)
        let superview = self.view
        //adding height constraint
        superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]", options: [], metrics:["height":UIScreen.main.bounds.height - BaseAskViewControllerSetting.askViewTopConstraintTopMargin], views: ["view":askView]) )
        
        //Adding side margin constriant
        superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: [], metrics: nil, views: ["view":askView]) )
    }
}

extension BaseAskViewController:AskViewDelegate {
    func doneButtonPressed() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.askTopConstraint.constant = UIScreen.main.bounds.height - BaseAskViewControllerSetting.askViewTopConstraintTopMargin
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
