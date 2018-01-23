//
//  DatabaseManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

protocol DatabaseOperationProtocol {
    func create(request:ServiceRequest)
    func read(id:String)
    func update(request:ServiceRequest)
    func delete(id:String)
    func monitor(id:String)
    func listen()
}


protocol DatabaseManagerProtocol:DatabaseOperationProtocol {
    func execute()
    func stopListening()
    func update(serviceRequest:ServiceRequest)
}
/*
 based on:-
 That each track/feed/alert/ will have there own instance of couchDB bucket.
 */
class CouchDatabaseManager :NSObject,DatabaseManagerProtocol {
    
    var dataBaseResponseListener:IDataBaseResponseListner!  //acts as a delegate
    var syncgatewayURL:URL?
    
    var serviceRequest:ServiceRequest! {
        didSet{
            
        }
    }
    
    init(withRequest request:ServiceRequest, dataBaseResponseListener:IDataBaseResponseListner ) {
        self.serviceRequest = request
        let urlPath = Constants.kSyncGatewayUrl + (serviceRequest.path?.rawValue)!
        print("urlPath = \(urlPath)")
        syncgatewayURL = URL(string:urlPath)
        self.serviceRequest = request
//        self.mapBlock = self.requestPath.mapBlock //set up the query map block
        self.dataBaseResponseListener = dataBaseResponseListener
    }
    
    //MARK:- DatabaseManagerProtocol
    
    func execute() {
        try! createDB(WithName: (serviceRequest.path?.rawValue)!)
        startReplication()
        
        let actionType = serviceRequest.pathArgs!.operationType!
        switch actionType {
            
        case .create:
            self.create(request: self.serviceRequest)
        case .read:
            self.read(id: self.serviceRequest.pathArgs!.documentID!)
        case .update:
            self.update(request: self.serviceRequest)
        case .delete:
            self.delete(id: self.serviceRequest.pathArgs!.documentID!)
        case .monitor:
            self.monitor(id: self.serviceRequest.pathArgs!.documentID!)
            createCBLMonitorView(mapBlock: self.monitorMapBlock)
            createCBLDocumentLiveQuery()
            monitorLiveQuery.start()
        case .listen:
            self.listen()
            createCBLView(mapBlock:self.listenMapBlock)
            createCBListLLiveQuery()
            //start listening to the changes on the database.
            listsLiveQuery.start()
        }
  
    }
    
    func stopListening() {
        let actionType = serviceRequest.pathArgs!.operationType!
        switch actionType {
        case .create:
            print("stop create")
        case .read:
            print("stop read")
        case .update:
            print("stop update")
        case .delete:
            print("stop delete")
        case .monitor:
            print("stop monitor")
            monitorLiveQuery.stop()
            stopAndCloseDatabase()
        case .listen:
            print("stop listen")
            listsLiveQuery.stop()
            stopAndCloseDatabase()
        }
    }
    
    
    func update(serviceRequest:ServiceRequest) {
        self.serviceRequest = serviceRequest
    }
    
    func create(request: ServiceRequest) {
        
    }
    
    func read(id: String) {
        
    }
    
    func update(request: ServiceRequest) {
        
    }
    
    func delete(id: String) {
        
    }
    
    func monitor(id: String) {
        
    }
    
    func listen() {
        self.listenMapBlock = {(doc,emit) in
            if let email = doc["email"] as? String ,email == "sujeet@gmail.com" {
                emit(email,doc)
            }
        }
    }
    
    //MARK:- couchbase live query and changes listener
    //changes which involves the Database livequery creation and observing changes in query(view)
    
    
    private var listsView:CBLView?
    private var monitorView:CBLView?
    private var listsLiveQuery: CBLLiveQuery!
    private var monitorLiveQuery: CBLLiveQuery!
    private var listRows : [CBLQueryRow]?
    private var monitoredRows :[CBLQueryRow]?
    var listenMapBlock:CBLMapBlock!
    var monitorMapBlock:CBLMapBlock!
    
    private func createCBLView(mapBlock:CBLMapBlock!) {
        listsView = database.viewNamed((self.serviceRequest.pathArgs?.operationType)!.rawValue)
        if listsView?.mapBlock == nil {
            listsView?.setMapBlock(mapBlock, version: Constants.CBLVersion)
        }
    }
    
    private func createCBLMonitorView(mapBlock:CBLMapBlock!) {
        monitorView = database.viewNamed((self.serviceRequest.pathArgs?.operationType)!.rawValue)
        if monitorView?.mapBlock == nil {
            monitorView?.setMapBlock(mapBlock, version: Constants.CBLVersion)
        }
    }
    
    private func createCBListLLiveQuery(){
        listsLiveQuery = listsView?.createQuery().asLive()
        listsLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
    }
    
    private func createCBLDocumentLiveQuery(){
        monitorLiveQuery = monitorView?.createQuery().asLive()
        let docID = self.serviceRequest.pathArgs?.documentID
        print("listening to doc = \(docID)")
        monitorLiveQuery.startKeyDocID = docID
        monitorLiveQuery.endKeyDocID = docID
        let keys = [docID]
        monitorLiveQuery.keys = keys
        monitorLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
    }
    
    override internal func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("observe Value change = \(String(describing: change))")
        if object as? NSObject == listsLiveQuery {
            reloadTaskLists()
        }
        if object as? NSObject == monitorLiveQuery {
            reloadDocument()
        }
    }
    
    private func reloadTaskLists() {
        //based on the list update..find a mechanism to find out the row update evnets like insert ,delete,update in row or section.
        listRows = listsLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        let testresult = Response(withPath: (serviceRequest.path?.rawValue)!)
        let count = listRows?.count ?? 12
        print("list row count = \(count)") 
        testresult.result = listRows
        self.dataBaseResponseListener.onListen(result:testresult )
    }
    //monitoredRows
    private func reloadDocument() {
        monitoredRows = monitorLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        let testresult = Response(withPath: (serviceRequest.path?.rawValue)!)
        let count = monitoredRows?.count ?? 12
        print("reloadDocument list row count = \(count)")
        testresult.result = monitoredRows
        self.dataBaseResponseListener.onChange(result:testresult )
    }
    
    //MARK:- couchbase creation sepcific changes
    //changes which involves the Database creation and starting replication
    var database: CBLDatabase!
    private var pusher: CBLReplication!
    private var puller: CBLReplication!
    private var syncError: NSError?
    
    private var conflictsLiveQuery: CBLLiveQuery?
    private var accessDocuments: Array<CBLDocument> = [];
    
    
    /// create database and add observer to notice changes.
    ///
    /// - Parameter name: name of Database.
    /// - Throws: exception
    private func createDB(WithName name:String)throws {
        let dbname = name
        let options = CBLDatabaseOptions()
        options.create = true
        
        try database = CBLManager.sharedInstance().openDatabaseNamed(dbname, with: options)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CouchDatabaseManager.observeDatabaseChange), name:Notification.Name.cblDatabaseChange, object: database)
    }

    
    @objc private func observeDatabaseChange(notification: Notification) {
        print("changes observed in data base via notification = \(notification)")
        if(!(notification.userInfo?["external"] as! Bool)) {
            return;
        }
        
        for change in notification.userInfo?["changes"] as! Array<CBLDatabaseChange> {
            if(!change.isCurrentRevision) {
                continue;
            }
            
            let changedDoc = database.existingDocument(withID: change.documentID);
            if(changedDoc == nil) {
                return;
            }
            
            let docType = changedDoc?.properties?["type"] as! String?;
            if(docType == nil) {
                continue;
            }
            
            if(docType != "task-list.user") {
                continue;
            }
            
            let username = changedDoc?.properties?["username"] as! String?;
            if(username != database.name) {
                continue;
            }
            
            accessDocuments.append(changedDoc!);
            
            NotificationCenter.default.addObserver(self, selector: #selector(CouchDatabaseManager.handleAccessChange), name: NSNotification.Name.cblDocumentChange, object: changedDoc);
        }
    }
    
    //delete the documents, access changes..user change..need to validate.
    @objc private func handleAccessChange(notification: Notification) throws {
        let change = notification.userInfo?["change"] as! CBLDatabaseChange;
        let changedDoc = database.document(withID: change.documentID);
        if(changedDoc == nil || !(changedDoc?.isDeleted)!) {
            return;
        }
        
        let deletedRev = try changedDoc?.getLeafRevisions()[0];
        let listId = (deletedRev?["taskList"] as! Dictionary<String, NSObject>)["id"] as! String?;
        if(listId == nil) {
            return;
        }
        
        accessDocuments.remove(at: accessDocuments.index(of: changedDoc!)!);
        let listDoc = database.existingDocument(withID: listId!);
        try listDoc?.purgeDocument();
        try changedDoc?.purgeDocument()
    }
    
    
    /// TO start replication with a session object. this session is provieded by the sync gateway
    ///
    /// - Parameter session: session object
    private func startReplication(withSession session:[String:String]) {
        guard kSyncEnabled else {
            return
        }
        syncError = nil
        
        let dateString = session["expires"]!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)!
        
        
        // TRAINING: Start push/pull replications
        pusher = database.createPushReplication(syncgatewayURL!)
        pusher.setCookieNamed(session["cookie_name"]!, withValue: session["session_id"]!, path: "/", expirationDate: date, secure: false)
        pusher.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller = database.createPullReplication(syncgatewayURL!)
//        puller.channels = self.userChannel
        puller.setCookieNamed(session["cookie_name"]!, withValue: session["session_id"]!, path: "/", expirationDate: date, secure: false)
        puller.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: puller)
        
        
        pusher.start()
        puller.start()
    }

    
    /// normal replication when when using in guest mode.
    private func startReplication() {
        
        // TRAINING: Start push/pull replications
        pusher = database.createPushReplication(syncgatewayURL!)

        pusher.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller = database.createPullReplication(syncgatewayURL!)
//        puller.channels = self.userChannel

        puller.continuous = true  // Runs forever in background
        
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: puller)

        pusher.start()
        puller.start()
    }
    
    private func stopReplication() {
        guard kSyncEnabled else {
            return
        }
        
        pusher.stop()
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller.stop()
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.cblReplicationChange, object: puller)
    }
    
    @objc private func replicationProgress(notification: NSNotification) {
        print("replicationProgress notification..")
        UIApplication.shared.isNetworkActivityIndicatorVisible = (pusher.status == .active || puller.status == .active)
        let appDelegate = UIApplication.shared.delegate
        let error = pusher.lastError as? NSError;
        if (error != syncError) {
            syncError = error
            if let errorCode = error?.code {
                NSLog("Replication Error: \(error!)")
                let errorResult = Response(withPath: (serviceRequest.path?.rawValue)!)
                errorResult.error = syncError
                self.dataBaseResponseListener.onError(result:errorResult )
                if errorCode == 401 {
                    Ui.showMessageDialog(
                        onController: (appDelegate?.window!?.rootViewController!)!,
                        withTitle: "Authentication Error",
                        withMessage:"Your username or password is not correct.",
                        withError: nil,
                        onClose: {
                            self.stopAndCloseDatabase()
                    })
                }
            }
        }
    }
    
    private func stopAndCloseDatabase() {
        stopReplication()
        do {
            try closeDatabase()
        } catch let error as NSError {
            NSLog("Cannot close database: %@", error)
        }
    }
    
    //PRIVATE
    //close and saves data to cbl
    private func closeDatabase() throws {
        try database.close()
    }
    
    private func deleteDatabase(dbName: String) {
        // Delete the database by using file manager. Currently CBL doesn't have
        // an API to delete an encrypted database so we remove the database
        // file manually as a workaround.
        let dir = NSURL(fileURLWithPath: CBLManager.sharedInstance().directory)
        let dbFile = dir.appendingPathComponent("\(dbName).cblite2")
        do {
            try FileManager.default.removeItem(at: dbFile!)
        } catch let err as NSError {
            NSLog("Error when deleting the database file: %@", err)
        }
    }
}

