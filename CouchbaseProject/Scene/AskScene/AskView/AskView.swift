//
//  AskTableView.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

protocol AskViewDelegate:NSObjectProtocol {
    func doneButtonPressed()
    func didBeginAsking()
}

class AskView: UIView,CBLDataSourceRequirment, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var cBLDataSource:AskCBLDataSource?
    weak var delegate:AskViewDelegate?
    
    ///----------for test purpose------
    let arrayData = ["ask1A","ask1AB","ask1AC","ask1AD"]
    var arrayDataSource:ArrayDataSource?
    //----------------------------------
    //MARK:- view creation
    class func instanceFromNib() -> AskView {
        let askview = UINib(nibName: "AskView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AskView
        return askview
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)!
//        setUp()        
    }

    func setupTest(){
        // Setup SearchController:
        let searchHeaderView = AskSearchView.instanceFromNib()
        searchHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        searchHeaderView.delegate = self
        self.tableView.tableHeaderView = searchHeaderView

        // Do any additional setup after loading the view, typically from a nib.
        arrayDataSource = ArrayDataSource(tableView: tableView, array: arrayData)
        
        //similarly other block can be defined for action in cell like edit on cell
        arrayDataSource?.tableItemSelectionHandler = { index in
            print("cell selected")
        }
    }
    
    func setUp(){
        //set the searchview as the table header and set its delegate to self
        // Setup SearchController:
        setUpDataSource()
        setupViewAndQuery()
    }
        
        //MARK:- CBLDataSourceRequirment protocol
        var database: CBLDatabase!
        var listsLiveQuery: CBLLiveQuery!
        var listRows : [CBLQueryRow]?
        
        func setUpDataSource(){
            //create a proper data source
            cBLDataSource = AskCBLDataSource(tableView: self.tableView, array: listRows!)
            //similarly other block can be defined for action in cell like edit on cell
            cBLDataSource?.tableItemSelectionHandler = { index in
                print("AskTableViewCell selected")
            }
        }
    
        func setupViewAndQuery(){
            // TRAINING: Writing a View
            let listsView = database.viewNamed("list/askList")
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
    
    // MARK: - UISearchController
    
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
//        let text = searchController.searchBar.text ?? ""
//        if !text.isEmpty {
//            listsLiveQuery.startKey = text
//            listsLiveQuery.prefixMatchLevel = 1
//        } else {
//            listsLiveQuery.startKey = nil
//            listsLiveQuery.prefixMatchLevel = 0
//        }
//        listsLiveQuery.endKey = listsLiveQuery.startKey
//        listsLiveQuery.queryOptionsChanged()
    }
}

extension AskView :AskSearchViewDelegate {
    func didAskQuestion(withText question:String){
        
    }
    func didBeginAsking() {
        if (delegate != nil){
            self.delegate?.didBeginAsking()
        }
    }
    func didPressDone(){
        if (delegate != nil){
            self.delegate?.doneButtonPressed()
        }
    }
}
