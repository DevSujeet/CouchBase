//
//  CBLTableViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/12/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit


/*
 class:CBLTableViewController
 use:- this class is used to render a list of document on a tableview.
 these documents are residing in the couchbase server accessed via sync gateway from sync mechanism.
 assumption:- before using this class, a proper data base should be created and replication should be started(push|pull).
 what it does?- it creates a cbl view from the data base and from the database it creates a CBL view, from the view we get livequery..
 live query monitors for any changes in the remote and local..Note the local database is being update as we will be syncing using push|pull.
 //GENERIC
 it also uses the generic class structure for table view.
 */

//this is a sample data source for cbltbleviewcontroller
class CBLDataSource: TableArrayDataSource<CBLQueryRow, CBLTableViewCell> {
    
    //Additional properties for further modification
    //    var cellActionDelegate:actionAbleCellDelegate?
    
    //    override func modifyOrUpdate(cell:inout TestTableViewCell) {
    //        cell.delegate = cellActionDelegate
    //    }
}
protocol CBLDataSourceRequirment {
    var database: CBLDatabase!{get set}
    var listsLiveQuery: CBLLiveQuery!{get set}
    var listRows : [CBLQueryRow]?{get set}
//    weak var tableView:UITableView!{get set}
    
    func setUpDataSource()
    func setupViewAndQuery()
}
class CBLTableViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!{
        didSet {
            tableView.separatorStyle = .none
        }
    }
    let emptyStateImageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let emptyStateLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 300,height: 20))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = ZeroStateInfo.ZeroStateLabelColor
        label.numberOfLines = 0
        return label
        
    }()
    
    let emptyStateTitleLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 300,height: 20))
        return label
        
    }()
    
    var cardCount = 0{
        didSet {
            if cardCount > 0 {
                self.emptyStateImageView.isHidden = true
                self.emptyStateLabel.isHidden = true
                self.emptyStateTitleLabel.isHidden = true
            }else {
                
                self.emptyStateImageView.isHidden = false
                self.emptyStateLabel.isHidden = false
                self.emptyStateTitleLabel.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addConstraintsToZeroState()
//        // Do any additional setup after loading the view.
//        //both these method are to be overriden in subclass.
//        //create a proper data source
//        setUpDataSource()
//        //create view to reload the table view with cbldata.
//        setupViewAndQuery()
    }

    func addConstraintsToZeroState() {
        self.view.addSubview(emptyStateImageView)
        self.view.addSubview(emptyStateLabel)
        
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageWidhtConstraint = NSLayoutConstraint(item: emptyStateImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        
        let imageHeightConstraint = NSLayoutConstraint(item: emptyStateImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        
        let imageCenterXConstraint =  NSLayoutConstraint(item: emptyStateImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let imageCenterYConstraint = NSLayoutConstraint(item: emptyStateImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.70, constant: 0)
        
        let labelWidhtConstraint = NSLayoutConstraint(item: emptyStateLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        
        let labelCenterXconstraint = NSLayoutConstraint(item: emptyStateLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let verticalLabelImageDistanceConstraint = NSLayoutConstraint(item: emptyStateLabel, attribute: .top, relatedBy: .equal, toItem: emptyStateImageView, attribute: .bottom, multiplier: 1, constant: 20)
        
        emptyStateImageView.addConstraint(imageWidhtConstraint)
        emptyStateImageView.addConstraint(imageHeightConstraint)
        
        view.addConstraint(imageCenterXConstraint)
        view.addConstraint(imageCenterYConstraint)
        
        emptyStateLabel.addConstraint(labelWidhtConstraint)
        view.addConstraint(labelCenterXconstraint)
        view.addConstraint(verticalLabelImageDistanceConstraint)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
