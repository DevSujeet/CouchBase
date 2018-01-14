//
//  ArrayDataProvider.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 12/4/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit

public class ArrayDataProvider<U>:DataProvider {
    // MARK: - Internal Properties
    var items: [[U]] = []
    
    // MARK: - Lifecycle
    init(array: [[U]]) {
        items = array
    }
    
    // MARK: - CollectionDataProvider protocol
//    public typealias T = U    //typealias is required if the class is non generic
    
    public func item(at indexPath: IndexPath) -> U? {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            return nil
        }
        return items[indexPath.section][indexPath.row]
    }
    
    public func updateItem(at indexPath: IndexPath, value: U) {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            return
        }
        items[indexPath.section][indexPath.row] = value
    }
    
    public func numberOfSections() -> Int {
        return items.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        guard section >= 0 && section < items.count else {
            return 0
        }
        return items[section].count
    }
    
    public func titleAtSection(in section: Int) -> String {
        return ""
    }
    
}
