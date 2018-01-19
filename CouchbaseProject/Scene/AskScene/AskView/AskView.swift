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

class AskView: UIView {//, UISearchResultsUpdating..not using search controller

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:AskViewDelegate?
    
    var askDataArray:[AskViewModel]?
    var askDataSource:AskDataSource?
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
    }

    func setupTest(){
        // Setup SearchController:
        setUpSearchHeader()
        
        //let dummy data
        let ask1 = AskViewModel(with: "ask1", owner: "test", type: "type")
        let ask2 = AskViewModel(with: "ask2", owner: "test", type: "type")
        let ask3 = AskViewModel(with: "ask3", owner: "test", type: "type")
        askDataArray = [ask1,ask2,ask3]

        //create a proper data source
        askDataSource = AskDataSource(tableView: self.tableView, array: askDataArray!)
        //similarly other block can be defined for action in cell like edit on cell
        askDataSource?.tableItemSelectionHandler = { index in
            print("AskTableViewCell selected")
        }
    }
    
    func setUp(){
        //set the searchview as the table header and set its delegate to self
        // Setup SearchController:
        setUpSearchHeader()
        
//        setUpDataSource()
//        setupViewAndQuery()
    }
    
    func setUpSearchHeader(){
        let searchHeaderView = AskSearchView.instanceFromNib()
        searchHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:70)
        searchHeaderView.delegate = self
        self.tableView.tableHeaderView = searchHeaderView

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
