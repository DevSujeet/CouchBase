//
//  AskTableView.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

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

        createAskQuery(with: question)
//        let serviceReq = self.
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
    
    var serviceRequest: ServiceRequest {
        get{
            return ResponsePathConfigurerManager.configure(requestPathConfigurer: self)
        }
    }
    
    func stopConnection() {
        responseListiner.stop(requestPath: serviceRequest, responseListner: self)
    }
    
    func StartConnection(){
        let requestPath = self.serviceRequest
        responseListiner.start(requestPath: requestPath, responseListner: self)
    }
    
    //MARK:-IResponsePathConfigurer
    
    func getResponseListenerPath() -> PathNames {
        return .ask
    }
    
    func getResponseListenerPathArgs() -> RequestPathArgs {
        let requestPathArgs = RequestPathArgs(with: nil, selectArgs: nil, sortOrder: nil, sortBy: nil, operationType: .listen, dataProp: nil)    //create a builder to create a specific requestPath.
        requestPathArgs.operationType = .listen
        return requestPathArgs
    }
    
    func getRequestType() ->RequestType {
        return .CBL
    }
    
    //MARK:- IResponseListener protocol
    func onStart(result: Response) {
        print("Ask onStart")
    }
    
    func onCreate(result:Response){
        print("Ask onCreate")
        if result.success! {
            print("objectcreated successfully")
            let createdID = result.result as! String
            print("createdID = \(createdID)")
            //once ID is created start monitoring the changes to this object
        }else{
            print("objectcreated failed")
        }
    }
    
    func onListen(result:Response) {
        print("Ask onListen")
        let askItems = result.result as? [CBLQueryRow] ?? []
        let count = askItems.count
        print("askItems count = \(count)")
        //remove previous data
        askDataArray = []
        for askItem in askItems {
            
            let data = askItem.value(forKey: "value")
//
            if let parsedObject = Mapper<AskModel>().map(JSONObject:data) {
                print("parsedObject = \(parsedObject)")
                let askItem = AskViewModel(with: parsedObject.name!, owner: parsedObject.owner!, type: parsedObject.type!)
                askDataArray?.append(askItem)
            }
            
        }

        askDataSource = AskDataSource(tableView: self.tableView, array: askDataArray!)
        self.tableView.reloadData()
        print(result.path)
    }
    
    func onChange(result: Response) //TO LISTEN TO A SINGLE DOCUMENT IN THE DB
    {
        print("Ask onListen")
        let askItems = result.result as? [CBLQueryRow] ?? []
        //        let count = askItems.count
        //remove previous data
        askDataArray = []
        for askItem in askItems {
            //            let qtext = askItem.value(forKey: "key") as? String
            //
            let data = askItem.value(forKey: "value")
            //
            if let parsedObject = Mapper<AskModel>().map(JSONObject:data) {
                print("parsedObject = \(parsedObject)")
                let askItem = AskViewModel(with: parsedObject.name!, owner: parsedObject.owner!, type: parsedObject.type!)
                askDataArray?.append(askItem)
            }
            
        }
        //        for index in 0..<count {
        //            let askItem = AskViewModel(with: "my sales + \(index)", owner: "sujeet", type: "ask")
        //            askDataArray?.append(askItem)
        //        }
        
        //TODO:
        //create  datasource with updated data array...finc out mech to insert data
        //without creating a new instance of datasource.
        askDataSource = AskDataSource(tableView: self.tableView, array: askDataArray!)
        self.tableView.reloadData()
        print(result.path)
    }
    
    
    func onError(result: Response) {
        print("Ask onError")
    }
    
    func onFinished(result: Response) {
        print("Ask onFinished")
    }

}

extension AskView {
    //operation
    func createAskQuery(with query:String) {
        //create a query object
        let ask = AskModel(JSON: [:])
        ask?.name = query
        
        let dataProp:[String:Any] = (ask?.toJSON())!
        let date:NSDate = NSDate()
        let dateString = Utility.dateToString(format: "yyyy-MM-dd HH:mm:ss", date: date as Date)
        let reqPathArgs = RequestPathArgs(with: dateString, selectArgs: nil, sortOrder: nil, sortBy: nil, operationType: .create, dataProp: nil)
        reqPathArgs.dataProp = dataProp
        
        let serviceRequest = ResponsePathConfigurerManager.configure(requestPathConfigurer: self)
        serviceRequest.pathArgs = reqPathArgs
        
        responseListiner.start(requestPath: serviceRequest, responseListner: self)
    }
}
