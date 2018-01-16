//
//  TestAskViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit
//A test class that uses the BaseAskViewController to display cbl data and a header view as table header view.
//most of the app has this similar structure.
class TrackAskViewController: BaseAskViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create headerView
        createHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createHeaderView() {
        let headerview = TitleHeaderView.instanceFromNib()
        headerview.backgroundColor = UIColor.red
        headerview.delegate = self
        headerview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        headerview.setUp(with: "Tracking", date: nil)
        self.tableView.tableHeaderView = headerview
        
//        headerview.translatesAutoresizingMaskIntoConstraints = false
//        headerview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]", options: [], metrics:["height":100], views: ["view":headerview]) )
//        headerview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(width)]", options: [], metrics:["width":UIScreen.main.bounds.width], views: ["view":headerview]) )
    }
}

extension TrackAskViewController:TitleHeaderViewDelegate {
    func didPressAlertIcon() {
        print("didPressAlertIcon")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alertController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController
        
        self.navigationController?.pushViewController(alertController!, animated: true)
    }
    
    func didPressProfileIcon() {
        print("profile screen in not implemented yet")
    }
}
