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
    
    @IBOutlet weak var tableView:UITableView!
    
    var database: CBLDatabase!
    var listsLiveQuery: CBLLiveQuery!
    var listRows : [CBLQueryRow]?

    var cBLDataSource:CBLDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        //both these method are to be overriden in subclass.
//        //create a proper data source
//        setUpDataSource()
//        //create view to reload the table view with cbldata.
//        setupViewAndQuery()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
