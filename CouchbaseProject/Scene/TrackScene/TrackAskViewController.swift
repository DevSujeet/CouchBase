//
//  TestAskViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit
//A test class that uses the BaseAskViewController to display cbl data and a header view as table header view.
//most of the app has this similar structure.
class TrackAskViewController: BaseAskViewController {
    
    var trackDataArray:[TrackViewModel]? = []
    var trackDataSource:TrackDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create headerView
        createHeaderView()
        
        //link up the data source
        //create a proper data source
        trackDataSource = TrackDataSource(tableView: self.tableView, array: trackDataArray!)
        //similarly other block can be defined for action in cell like edit on cell
        trackDataSource?.tableItemSelectionHandler = { index in
            print("TrackTableViewCell selected")
        }
        
        let askModel = AskModel(JSON: [:])
        let string = askModel?.toJSON()
        print(string)
        startConnection()
    }

    deinit {
        stopConnection()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createHeaderView() {
        let headerview = TitleHeaderView.instanceFromNib()
        headerview.delegate = self
        headerview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 85)
        headerview.setUp(with: "Tracking", date: nil)
        self.tableView.tableHeaderView = headerview

    }
}

extension TrackAskViewController:TitleHeaderViewDelegate {
    func didPressAlertIcon() {
        print("didPressAlertIcon")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alertController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController
        
        self.navigationController?.pushViewController(alertController!, animated: true)
    }
    
    func didPressProfileIcon() {
        print("profile screen in not implemented yet")
    }
}


extension TrackAskViewController: ResponseListenerProtocol {
    
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
    
    func startConnection(){
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
        return .track
    }
    
    func getResponseListenerPathArgs() -> RequestPathArgs {
        return RequestPathArgs(with: nil, selectArgs: nil, sortOrder: nil, sortBy: nil, operationType: .listen, dataProp: nil)    //create a builder to create a specific requestPath.
    }
    
    func getRequestType() ->RequestType {
        return .CBL
    }
    
    //MARK:- IResponseListener protocol
    func onStart(result: Response) {
        print("TrackAskViewController onStart")
    }
     func onCreate(result:Response){
        print("TrackAskViewController onCreate")
    }
    func onListen(result:Response) {
        print("TrackAskViewController onChange")
        
        let trackItems = result.result as? [CBLQueryRow] ?? []
        let count = trackItems.count
        //remove previous data
        trackDataArray = []
        for index in 0..<count {
            let trackItem = TrackViewModel()
            trackDataArray?.append(trackItem)
        }
        
        //TODO:
        //create  datasource with updated data array...finc out mech to insert data
        //without creating a new instance of datasource.
        trackDataSource = TrackDataSource(tableView: self.tableView, array: trackDataArray!)
        
        self.tableView.reloadData()
        print(result.path)
    }
    func onChange(result: Response) {
//        print("TrackAskViewController onChange")
//
//        let trackItems = result.result as? [CBLQueryRow] ?? []
//        let count = trackItems.count
//        //remove previous data
//        trackDataArray = []
//        for index in 0..<count {
//            let trackItem = TrackViewModel()
//            trackDataArray?.append(trackItem)
//        }
//
//        //TODO:
//        //create  datasource with updated data array...finc out mech to insert data
//        //without creating a new instance of datasource.
//        trackDataSource = TrackDataSource(tableView: self.tableView, array: trackDataArray!)
//
//        self.tableView.reloadData()
//        print(result.path)
    }
    
    func onError(result: Response) {
        print("TrackAskViewController onError")
    }
    
    func onFinished(result: Response) {
        print("TrackAskViewController onFinished")
    }
    
}
