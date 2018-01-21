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

//The view that is hold the container where user can create a ask query through voice or through typing there content.
class AskView: UIView {//, UISearchResultsUpdating..not using search controller

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:AskViewDelegate?
    
    var askDataArray:[AskViewModel]? = []
    var askDataSource:AskDataSource?
    //----------------------------------
    //MARK:- view creation
    class func instanceFromNib() -> AskView {
        let askview = UINib(nibName: "AskView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AskView
        return askview
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)!       
    }

    func setup(){
        // Setup SearchController:
        setUpSearchHeader()

        //create a proper data source
        askDataSource = AskDataSource(tableView: self.tableView, array: askDataArray!)
        //similarly other block can be defined for action in cell like edit on cell
        askDataSource?.tableItemSelectionHandler = { index in
            print("AskTableViewCell selected")
        }
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
        StartConnection()
    }
    func didPressDone(){
        if (delegate != nil){
            self.delegate?.doneButtonPressed()
        }
        stopConnection()
    }
}

extension AskView : ResponseListenerProtocol {
    
    var responseListiner :ResponseListenerRegistrationService {
        get {
            return ResponseListenerRegistrationService.shared
        }
    }
    
    var requestPath: RequestPath {
        get{
            return ResponsePathConfigurerManager.configure(requestPathConfigurer: self) as! CBLRequestPath
        }
    }
    
    func stopConnection() {
        responseListiner.stop(requestPath: requestPath, responseListner: self)
    }
    
    func StartConnection(){
        let requestPath = self.requestPath as! CBLRequestPath
        requestPath.mapBlock = {(doc,emit) in
            
            if let type = doc["type"] as? String ,type == "task-list" {
                emit(type,doc)
            }
        }
        responseListiner.start(requestPath: requestPath, responseListner: self)
    }
    
    //MARK:-IResponsePathConfigurer
    
    func getResponseListenerPath() -> String? {
        return "ask"
    }
    
    func getResponseListenerPathArgs() -> [String : Any]? {
        return [:]
    }
    
    
    //MARK:- IResponseListener protocol
    func onStart(result: Result) {
        print("Ask onStart")
    }
    
    func onChange(result: Result) {
        print("Ask onChange")
        let askItems = result.result as? [CBLQueryRow] ?? []
        let count = askItems.count
        //remove previous data
        askDataArray = []
        for index in 0...count-1 {
            let askItem = AskViewModel(with: "my sales + \(index)", owner: "sujeet", type: "ask")
            askDataArray?.append(askItem)
        }

        //TODO:
        //create  datasource with updated data array...finc out mech to insert data
        //without creating a new instance of datasource.
        askDataSource = AskDataSource(tableView: self.tableView, array: askDataArray!)
        self.tableView.reloadData()
        print(result.path)
    }
    
    func onError(result: Result) {
        print("Ask onError")
    }
    
    func onFinished(result: Result) {
        print("Ask onFinished")
    }
    
}
