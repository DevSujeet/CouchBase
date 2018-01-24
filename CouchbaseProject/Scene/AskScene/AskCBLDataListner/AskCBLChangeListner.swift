//
//  AskCBLChangeListner.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/17/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
/*
 {
 "name": "Test",
 "owner": "usertest",
 "type": "task-list"
 }
 */

//not being used now.
/**
class AskCBLChangeListner:NSObject,CBLFetchResultControllerDelegate {
    
    let cblFetchResultController:CBLFetchResultController = CBLFetchResultController(withViewnNamed: "AskView", version: Constants.CBLVersion)
    
    override init() {
        super.init()
        cblFetchResultController.delegate = self
        cblFetchResultController.database = CBLDataHelper.sharedCBLDataHelper.database
        //provide the map block that is view in couch terms...
        cblFetchResultController.mapBlock = { (doc, emit) in
            if let name = doc["name"] as? String {  //, type == "task-list"
                emit(name, doc)
            }
        }
        
        cblFetchResultController.setupViewAndQuery()
    }
    
    //MARK:- CBLFetchResultControllerDelegate
    func controllerWillChangeContent(_ controller: CBLFetchResultController) {
        
    }
    
    func controllerDidChangeContent(_ controller: CBLFetchResultController) {
        
    }
    
    func controller(_ controller: CBLFetchResultController, didChangeSection sectionInfo: CBLFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: CBLFetchedResultsChangeType) {
        
    }
    
    func controller(_ controller: CBLFetchResultController, didChangeObject anObject: AnyObject, atIndexPath indexPath: IndexPath?, forChangeType type: CBLFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controller(_ controller: CBLFetchResultController, didFetchUpdatedList updatedList: [AnyObject]) {
        print("total count = \(updatedList.count)")
    }

}
**/
