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

class CBLDataSource: TableArrayDataSource<CBLQueryRow, CBLTableViewCell> {
    
    //Additional properties for further modification
    //    var cellActionDelegate:actionAbleCellDelegate?
    
    //    override func modifyOrUpdate(cell:inout TestTableViewCell) {
    //        cell.delegate = cellActionDelegate
    //    }
}
class CBLTableViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var database: CBLDatabase!
    
    var listsLiveQuery: CBLLiveQuery!
    var listRows : [CBLQueryRow]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - KVO
    
    // TRAINING: Responding to Live Query changes
    /*
     from setupandview query
     listsLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("change = \(change)")
        if object as? NSObject == listsLiveQuery {
            reloadTaskLists()
        }
    }
    
    // MARK: - Database
    
    /*
     "source": "Applications developer",
     "name": name,
     "owner": username
     */
    func setupQuery() {
        let peridicate = NSPredicate(format: "source == %@","Applications developer" )
        let selectColumn = ["source","name","owner"]
        let sortDesc : NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        //        let queryBuilder = CBLQueryBuilder(database: database, select: selectColumn, where: <#T##String#>, orderBy: <#T##[Any]?#>)
        let queryBuilder = try! CBLQueryBuilder(database: database, select: selectColumn, wherePredicate: peridicate, orderBy:[sortDesc])
        let queryObj : CBLQuery = queryBuilder.createQuery(withContext: nil) //it is not a live query
        
        queryObj.descending = true
        
        //        queryObj.skip = startindex as! UInt
        //        queryObj.limit = limit
        let result : CBLQueryEnumerator = try! queryObj.run()
        
        var listData = [AnyObject]()
        
        while let row = result.nextRow() {
            
            listData.append(row)
        }
        
        listRows = listData as? [CBLQueryRow] ?? nil
        self.tableView.reloadData()
    }
    
    
    func setupViewAndQuery() {
        // TRAINING: Writing a View
        let listsView = database.viewNamed("list/listsByName")
        if listsView.mapBlock == nil {
            listsView.setMapBlock({ (doc, emit) in
                if let type: String = doc["source"] as? String, let name = doc["name"], let owner = doc["owner"]
                {  //, type == "task-list"
                    emit(type, [name,owner])
                }
            }, version: "1.0")
        }
        
        // TRAINING: Running a Query
        listsLiveQuery = listsView.createQuery().asLive()
        listsLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        listsLiveQuery.start()
    }
    
    func reloadTaskLists() {
        listRows = listsLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        tableView.reloadData()
    }

}