//
//  ViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/16/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

class AlertViewController: BaseAskViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func createHeaderView(){
        let headerView = TitleWithBackView.instanceFromNib()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        headerView.setUp(withTitle: "Alert")
        headerView.delegate = self
        
        self.tableView.tableHeaderView = headerView
    }
    
}

extension AlertViewController:TitleWithBackViewDelegate {
    func didPressedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
