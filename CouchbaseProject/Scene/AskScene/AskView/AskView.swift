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

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.separatorStyle = .none
        }
    }
    
    weak var delegate:AskViewDelegate?
    
    var askDataArray:[AskViewModel]? = []
    var askDataSource:AskDataSource?
    
    var documentId:String?
    var baseOperation:BaseOperation?    //to lnow whicj operarion is taking place now
    var dataProperties:[String:Any]?    //used while creating a object
    
    var serviceRequest:ServiceRequest?

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

        //create a proper data source and action defination on cell action.
        askDataSource = AskDataSource(tableView: self.tableView, array: askDataArray!)
        //similarly other block can be defined for action in cell like edit on cell
        askDataSource?.tableItemSelectionHandler = { index in
            print("AskTableViewCell selected")
        }
    }

    //setup header view for search module. Has a search bar to allow asking question.
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
        let date = Date()
        let dateString = Utility.dateToString(format: Constants.docIDDateFormat, date: date) + "-Sujeet"
        self.documentId = dateString
        self.baseOperation = .create
//        StartConnection()
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

    //MARK- ask view actions
    
    
    func stopConnection() {
        //nothing to stop if no request is present.
        if self.serviceRequest != nil {
            responseListiner.stop(requestPath: self.serviceRequest!, responseListner: self)
        }
        
    }
    
    func StartConnection(){
        self.serviceRequest = ResponsePathConfigurerManager.configure(requestPathConfigurer: self)
        responseListiner.start(requestPath: self.serviceRequest!, responseListner: self)
    }
    
    //MARK:-IResponsePathConfigurer
    
    func getResponseListenerPath() -> PathNames {
        return .ask
    }
    
    func getResponseListenerPathArgs() -> RequestPathArgs {
        let requestPathArgsBuilder = RequestPathArgsBuilder() //create a builder to create a specific requestPath.
        requestPathArgsBuilder.setOperationType(operationType: self.baseOperation)
        requestPathArgsBuilder.setDocoumentId(documentID: self.documentId)
        requestPathArgsBuilder.setDataProp(dataProp: dataProperties)
        let requestPathArgs = requestPathArgsBuilder.buildPathArgs()
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
            stopConnection()
            //after stopping the connection..start listening to the new document for changes
            self.dataProperties = nil
            self.baseOperation = .monitor
            StartConnection()
        }else{
            print("objectcreated failed")
            stopConnection()
        }
        
           //STOP THE CONNECTION
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

            let data = askItem.value(forKey: "value")
            //
            if let parsedObject = Mapper<UserQuery>().map(JSONObject:data) {
                print("parsedObject = \(parsedObject)")
                let askItem = AskViewModel(with: (parsedObject.query?.query)!, owner: (parsedObject.query?.query)!, type: (parsedObject.query?.query)!)
                askDataArray?.append(askItem)
            }
            
        }

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
    //operations on Ask
    func createAskQuery(with query:String) {
        //create a query object
        let date:Date = Date()
//        let dateString = Utility.dateToString(format: Constants.docIDDateFormat, date: date as Date)
        let docId = self.documentId
        let userQuery = UserQuery(JSON: [:])
        userQuery?.query?.id = docId
        userQuery?.query?.deviceType = "iPhone"
        userQuery?.query?.query = query
        userQuery?.query?.userId = "sujeet@cuddle.ai"
        
        userQuery?.user?.name = "sujeet"
        userQuery?.user?.email = "sujeet@cuddle.ai"
        userQuery?.user?.created = date
        let dataProp:[String:Any] = (userQuery?.toJSON())!
        print("dataProp = \(dataProp)")
        self.dataProperties = dataProp
        
        StartConnection() 
    }
}
