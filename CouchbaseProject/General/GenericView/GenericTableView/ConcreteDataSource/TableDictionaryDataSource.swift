//
//  TableDictionaryDataSource.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 12/4/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit

class TableDictionaryDataSource<U,T,Cell:UITableViewCell>:TableDataSource<DictionaryDataProvider<U,T>,Cell> where
Cell:ConfigurableCell,Cell.T == T , U:CustomStringConvertible & Hashable{
    
    
    public init(tableView: UITableView, dictionary: [U:[T]]) {
        let provider = DictionaryDataProvider(dict: dictionary)
        super.init(tableView: tableView, provider: provider)
    }
    
    // MARK: - Public Methods
    public func item(at indexPath: IndexPath) -> T? {
        return provider.item(at: indexPath)
    }
    
    public func updateItem(at indexPath: IndexPath, value: T) {
        provider.updateItem(at: indexPath, value: value)
    }
}
