//
//  CoreDataProvider.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/17/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
import CoreData

//check on how to use it. incomplete
class CoreDataProvider<U:NSManagedObject>:DataProvider {
    
//    // MARK: - Internal Properties
//    var items: [[U]] = []
//    
//    // MARK: - Lifecycle
//    init(array: [[U]]) {
//        items = array
//    }
    
    var frc:NSFetchedResultsController<NSManagedObject>!
    
    init(withFetchedResultController controller:NSFetchedResultsController<NSFetchRequestResult>) {
        self.frc = controller as? NSFetchedResultsController<NSManagedObject>
    }
    // MARK: - CollectionDataProvider protocol
    //    public typealias T = U    //typealias is required if the class is non generic
    
    public func item(at indexPath: IndexPath) -> U? {
        let model = self.frc.object(at: indexPath) as? U
        return model
    }
    
    public func updateItem(at indexPath: IndexPath, value: U) {
//        guard indexPath.section >= 0 &&
//            indexPath.section < items.count &&
//            indexPath.row >= 0 &&
//            indexPath.row < items[indexPath.section].count else
//        {
//            return
//        }
//        items[indexPath.section][indexPath.row] = value
    }
    
    public func numberOfSections() -> Int {
        return self.frc.sections?.count ?? 0
    }
    
    public func numberOfItems(in section: Int) -> Int {
        let cardCount =  self.frc.sections![section].numberOfObjects
        return cardCount
    }
    
    public func titleAtSection(in section: Int) -> String {
        return self.frc.sections![section].name
    }
}
