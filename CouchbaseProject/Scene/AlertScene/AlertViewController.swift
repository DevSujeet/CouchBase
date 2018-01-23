//
//  ViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/16/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

class AlertViewController: BaseAskViewController {

    var alertDataArray:[AlertViewModel]? = []
    var alertDataSource:AlertDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createHeaderView()
        
        //link up the data source
        //create a proper data source
        alertDataSource = AlertDataSource(tableView: self.tableView, array: alertDataArray!)
        //similarly other block can be defined for action in cell like edit on cell
        alertDataSource?.tableItemSelectionHandler = { index in
            print("AlertTableViewCell selected")
        }
        
        StartConnection()
    }
    
    deinit {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func createHeaderView(){
        let headerView = TitleWithBackView.instanceFromNib()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        headerView.setUp(withTitle: "Alert")
        headerView.delegate = self
        
        self.tableView.tableHeaderView = headerView
    }
    
}

extension AlertViewController:TitleWithBackViewDelegate {
    func didPressedBackButton() {
        stopConnection()
        self.navigationController?.popViewController(animated: true)
    }
}

extension AlertViewController: ResponseListenerProtocol {
    
    var responseListiner :ResponseListenerRegistrationService {
        get {
            return ResponseListenerRegistrationService.shared
        }
    }
    
    var requestPath: ServiceRequest {
        get{
            return ResponsePathConfigurerManager.configure(requestPathConfigurer: self) 
        }
    }
    
    func stopConnection() {
        responseListiner.stop(requestPath: requestPath, responseListner: self)
    }
    
    func StartConnection(){
        let requestPath = self.requestPath
        
//        requestPath.mapBlock = {(doc,emit) in
//            
//            if let type = doc["type"] as? String ,type == "task-list" {
//                emit(type,doc)
//            }
//        }
        
        responseListiner.start(requestPath: requestPath, responseListner: self)
    }
    
    //MARK:-IResponsePathConfigurer
    
    func getResponseListenerPath() -> PathNames {
        return .alert
    }
    
    func getResponseListenerPathArgs() -> RequestPathArgs {
        return RequestPathArgs(with: nil, selectArgs: nil, sortOrder: nil, sortBy: nil, operationType: .listen, dataProp: nil)    //create a builder to create a specific requestPath.
    }
    
    func getRequestType() ->RequestType {
        return .HTTP
    }
    
    //MARK:- IResponseListener protocol
    func onStart(result: Response) {
        print("AlertViewController onStart")
    }
    func onCreate(result:Response){
        print("AlertViewController onCreate")
    }
    func onListen(result:Response) {
        print("AlertViewController onChange")
        
        let trackItems = result.result as? [CBLQueryRow] ?? []
        let count = trackItems.count
        //remove previous data
        alertDataArray = []
        for index in 0..<count {
            let alertItem = AlertViewModel()
            alertDataArray?.append(alertItem)
        }
        
        //TODO:
        //create  datasource with updated data array...finc out mech to insert data
        //without creating a new instance of datasource.
        alertDataSource = AlertDataSource(tableView: self.tableView, array: alertDataArray!)
        
        self.tableView.reloadData()
        print(result.path)
    }
    
    func onChange(result: Response) {
//        print("AlertViewController onChange")
//        
//        let trackItems = result.result as? [CBLQueryRow] ?? []
//        let count = trackItems.count
//        //remove previous data
//        alertDataArray = []
//        for index in 0..<count {
//            let alertItem = AlertViewModel()
//            alertDataArray?.append(alertItem)
//        }
//        
//        //TODO:
//        //create  datasource with updated data array...finc out mech to insert data
//        //without creating a new instance of datasource.
//        alertDataSource = AlertDataSource(tableView: self.tableView, array: alertDataArray!)
//        
//        self.tableView.reloadData()
//        print(result.path)
    }
    
    func onError(result: Response) {
        print("AlertViewController onError")
    }
    
    func onFinished(result: Response) {
        print("AlertViewController onFinished")
    }
    
}
