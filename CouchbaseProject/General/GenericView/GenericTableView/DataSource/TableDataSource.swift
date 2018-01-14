//
//  GenericTableDataSource.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 12/4/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit
/// Encapsulating the Boilerplate: TableDataSource
///With the above abstractions in place, it is possible to start implementing a base class that will
///encapsulate the common boilerplate required to create a data source for a collection/table view.

class TableDataSource<Provider:DataProvider,Cell:UITableViewCell> :NSObject,
UITableViewDataSource,
UITableViewDelegate where Cell:ConfigurableCell, Provider.T == Cell.T {
    
    // MARK: - Private Properties
    //CollectionDataSource needs to know which collection view instance it will be acting upon and through which specific Provider.
    let provider: Provider
    let tableView: UITableView
    
    // MARK: - Lifecycle
    init(tableView: UITableView, provider: Provider) {
        self.tableView = tableView
        self.provider = provider
        super.init()
        setUp()
    }
    
    func setUp() {
        tableView.dataSource = self
        tableView.delegate = self
        //register the cell
        tableView.register(UINib(nibName: Cell.nibForCell, bundle: nil), forCellReuseIdentifier: Cell.reuseIdentifierForCell)
//        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifierForCell)
    }
    
    //MARK:- UITableViewDelegate Methods
    /*
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
     
     }
     
     func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
     
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
     
     }
     
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
     
     }
     
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
     
     }
     
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
     
     }
       */
     // MARK: - Delegates
     public var tableItemSelectionHandler: ItemSelectionHandlerType?
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableItemSelectionHandler?(indexPath)
     }

    //MARK:- UITableViewDataSource
    // Default is 1 if not implemented
    func numberOfSections(in tableView: UITableView) -> Int{
        let sectionCount =  provider.numberOfSections()
        print("sectionCount = \(sectionCount) in generic table")
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return provider.numberOfItems(in: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifierForCell, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
//        return ""
        return provider.titleAtSection(in: section)
    }
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
//        return "Header"
//    }
    
}


