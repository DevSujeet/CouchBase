//
//  DictionaryDataProvider.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 12/4/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit

class DictionaryDataProvider<U:Hashable & CustomStringConvertible,T>:DataProvider {
    
    // MARK: - Internal Properties
    var items: [U:[T]] = [:]
    
    // MARK: - Lifecycle
    init(dict: [U:[T]]) {
        items = dict
    }
    
    // MARK: - CollectionDataProvider
    
    public func numberOfSections() -> Int {
        return items.keys.count
    }
    public func numberOfItems(in section: Int) -> Int {
        
        guard section >= 0 && section < items.keys.count else {
            return 0
        }
        let keyForSection = self.keyAt(section: section)
        let arrayOfObject = items[keyForSection]
        
        return arrayOfObject?.count ?? 0
    }
    
    public func item(at indexPath: IndexPath) -> T? {
        
        guard indexPath.section >= 0 &&
            indexPath.section < items.keys.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[self.keyAt(section: indexPath.section)]!.count else
        {
            return nil
        }
        return items[self.keyAt(section: indexPath.section)]![indexPath.row]
    }
    
    public func titleAtSection(in section: Int) -> String {
        return self.keyAt(section: section).description
    }
    
    public func updateItem(at indexPath: IndexPath, value: T){
        guard indexPath.section >= 0 &&
            indexPath.section < items.keys.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[self.keyAt(section: indexPath.section)]!.count else
        {
            return
        }
    }
    
    //MARK:- Private Function
    //override in subClass/Concrete class to get desired result
    func keyAt(section:Int) -> U {
        let key = Array(items.keys)[section]
        return key
    }
}
