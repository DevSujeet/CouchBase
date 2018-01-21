//
//  CBLFetchResultController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/17/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
public protocol CBLFetchedResultsSectionInfo {
    
    
    /* Name of the section
     */
    var name: String { get }
    
    
    /* Title of the section (used when displaying the index)
     */
    var indexTitle: String? { get }
    
    
    /* Number of objects in section
     */
    var numberOfObjects: Int { get }
    
    
    /* Returns the array of objects in the section.
     */
    var objects: [Any]? { get }
}

enum CBLFetchedResultsChangeType : UInt {
    
    case insert
    
    case delete
    
    case move
    
    case update
}

protocol CBLFetchResultControllerDelegate:NSObjectProtocol {
    func controllerWillChangeContent(_ controller:CBLFetchResultController)
    func controllerDidChangeContent(_ controller:CBLFetchResultController)
    
    func controller(_ controller: CBLFetchResultController, didChangeSection sectionInfo: CBLFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: CBLFetchedResultsChangeType)
    
    func controller(_ controller: CBLFetchResultController, didChangeObject anObject: AnyObject, atIndexPath indexPath: IndexPath?, forChangeType type: CBLFetchedResultsChangeType, newIndexPath: IndexPath?)
    
    func controller(_ controller:CBLFetchResultController, didFetchUpdatedList updatedList:[AnyObject])
}

class CBLFetchResultController :NSObject{
    
    init(withViewnNamed name:String,version:String) {
        self.viewName = name
        self.viewVersion = version
    }
    var viewName:String?
    /*
        An arbitrary string that will be stored persistently along with the index. Usually a string literal like @"1". If you subsequently change the functionality of the map or reduce function, change this string as well: the call will detect that it's different and will clear the index so it can be rebuilt by the new function.
     
     keep a global version variable..in constants file for all the CBLQuery view
     */
    //MARK:- Properties for live query
    var viewVersion:String?
    var database: CBLDatabase!
    
    var listsLiveQuery: CBLLiveQuery!
    var listRows : [CBLQueryRow]?
    var mapBlock:CBLMapBlock!   //to be provided by the caller
    
    weak var delegate:CBLFetchResultControllerDelegate?
    
    func setupViewAndQuery(){
        let listsView = database.viewNamed(self.viewName!)
        if listsView.mapBlock == nil {
            listsView.setMapBlock(self.mapBlock, version: self.viewVersion!)
        }
        listsLiveQuery = listsView.createQuery().asLive()
        listsLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        listsLiveQuery.start()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("observe Value change = \(String(describing: change))")
        if object as? NSObject == listsLiveQuery {
            reloadTaskLists()
        }
    }
    
    //TODO
    func reloadTaskLists() {
        if delegate != nil {
            self.delegate?.controllerWillChangeContent(self)
        //TODO
        //based on the list update..find a mechanism to find out the row update evnets like insert ,delete,update in row or section.
            listRows = listsLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        
        
            self.delegate?.controller(self, didFetchUpdatedList: listRows!)
        
        
            self.delegate?.controllerDidChangeContent(self)
        }
    }
    
    //MARK:- Properties for queryBuilder
    //extra functionality with query builder
    /// to create a queryBuilder to get data using perodicate, sortdescriptor..note this is not a live query.
    var predicate:NSPredicate?
    var selectColumn:[String]?
    var sortDescriptors:[NSSortDescriptor]?
    var desending:Bool = true   //true by default
    
    func setupQueryAndPerform() {
//        let peridicate = NSPredicate(format: "source == %@","Applications developer" )
//        let selectColumn = ["source","name","owner"]
//        let sortDesc : NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        let sortDescriptors = [sortDesc]
//        //        let queryBuilder = CBLQueryBuilder(database: database, select: selectColumn, where: <#T##String#>, orderBy: <#T##[Any]?#>)
        
        let queryBuilder = try! CBLQueryBuilder(database: database, select: selectColumn, wherePredicate: predicate!, orderBy:sortDescriptors)
        let queryObj : CBLQuery = queryBuilder.createQuery(withContext: nil) //it is not a live query
        
        queryObj.descending = desending
        
        //        queryObj.skip = startindex as! UInt
        //        queryObj.limit = limit
        let result : CBLQueryEnumerator = try! queryObj.run()
        
        var listData = [AnyObject]()
        
        while let row = result.nextRow() {
            
            listData.append(row)
        }
        
        listRows = listData as? [CBLQueryRow] ?? nil
        //        self.tableView.reloadData()
    }
    
    //MARK:-data base operation
    //like update / delete to can be performed here
    func addDocument(withProperties properties:[String : Any], withId docId:String) -> CBLSavedRevision? {
        
        guard let doc = database.document(withID: docId) else {
//            Ui.showMessageDialog(onController: self, withTitle: "Error",
//                                 withMessage: "Couldn't save task list")
            return nil
        }
        
        do {
            return try doc.putProperties(properties)
        } catch let error as NSError {
//            Ui.showMessageDialog(onController: self, withTitle: "Error",
//                                 withMessage: "Couldn't save task list", withError: error)
            return nil
        }
    }
    
}
