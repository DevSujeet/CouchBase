//
//  GenericViewProtocol.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 12/4/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit

/*
    look at DataListViewController class to understand how to use this genric class for collection/tableview
 steps
 1. decide the type of data (Array or dictionary) and also the unit of data(is what is array or dic made of! as per eg:- String in this case)
 2. create a cell subclass implementing the congifurable protocol(decide the type of data uniteg:ListTableViewCell)
 3 create a class overriding concrete data source class also add here/update the collection delegate.
 
 eg/:- concrete data source
 
 class ArrayDataSource: TableArrayDataSource<String, ListTableViewCell> {

 }
 
 In the view did load
 // Do any additional setup after loading the view, typically from a nib.
    arrayDataSource = ArrayDataSource(tableView: listTableView, array: arrayData)
 
 //similarly other block can be defined for action in cell like edit on cell
    arrayDataSource?.tableItemSelectionHandler = { index in
    print("cell selected")
 }
 */

//resuable cell
public protocol ReusableCell {
    static var reuseIdentifierForCell: String { get }
    static var nibForCell:String {get}
}

public extension ReusableCell {
    static var reuseIdentifierForCell: String {
        return String(describing: self)
    }
}

//ConfigurableCell
public protocol ConfigurableCell: ReusableCell {
    associatedtype T
    
    func configure(_ item: T, at indexPath: IndexPath)
}

//Abstracting the Data Source: DataProvider
public protocol DataProvider {
    associatedtype T
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> T?
    func titleAtSection(in section: Int) ->String
    
    func updateItem(at indexPath: IndexPath, value: T)
}

//define the action on collectioncell
public typealias ItemSelectionHandlerType = (IndexPath) -> Void
