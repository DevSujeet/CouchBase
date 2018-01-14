//
//  LoginSerices.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/9/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

//protocol LoginDelegate:NSObjectProtocol {
//    func loginCompleted(with status:Bool,withParams:[String:String])
//}

protocol loginWithReplicationProtocol {
    var database: CBLDatabase! {get set}
    var pusher: CBLReplication! {get set}
    var puller: CBLReplication! {get set}
    var syncError: NSError? {get set}
    
    var loginAsGuest:Bool {get set}
    
}
//let kLoginFlowEnabled = true
//let kEncryptionEnabled = false
//let kSyncEnabled = true
//let kSyncGatewayUrl = URL(string: "http://127.0.0.1:4984/todo/")! //172.18.8.115 //127.0.0.1
//let kLoggingEnabled = false
//let kUsePrebuiltDb = true
//let kConflictResolution = false

class LoginWithReplicationSerivice:loginWithReplicationProtocol,AuthenticatorProtocol {
    var database: CBLDatabase!
    
    var pusher: CBLReplication!
    
    var puller: CBLReplication!
    
    var syncError: NSError?
    
    var loginAsGuest:Bool = false
    
    weak var delegate:AuthenticatorDelegate?
    
    func authenticate(user username:String, withPassword password:String) {//startLoginWith(username:String, andPassword password:String? = "")}
        //open database
        do{
            try openDataBaseWith(username: username,andPassword: password)
            //start auth with replication
            startLoginWithReplication(username: username,andPassword: password)
        }catch {
            
        }
        
    }
    
    func openDataBaseWith(username:String, andPassword password:String? = "") throws {
        let dbname = username
        let options = CBLDatabaseOptions()
        options.create = true
        
        try database = CBLManager.sharedInstance().openDatabaseNamed(dbname, with: options)
        
    }
    
    /// start login with replication.couchbase base has a mechanism where it allows for authenticationbase don wheather a particular user is assigned to access a particular channel or not.
    ///
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    func startLoginWithReplication(username:String, andPassword password:String? = "") {
        
        syncError = nil
        
        // TRAINING: Start push/pull replications
        pusher = database.createPushReplication(kSyncGatewayUrl)
        pusher.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller = database.createPullReplication(kSyncGatewayUrl)
//        puller.channels = [username + "-" + "task-list"]
        puller.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: puller)
        
//        if kLoginFlowEnabled {
            let authenticator = CBLAuthenticator.basicAuthenticator(withName: username, password: password!)
            pusher.authenticator = authenticator
            puller.authenticator = authenticator
//        }
        
        pusher.start()
        puller.start()
    }
    
    func stopReplication() {
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
    
    @objc func replicationProgress(notification: NSNotification) {
        UIApplication.shared.isNetworkActivityIndicatorVisible =
            (pusher.status == .active || puller.status == .active)
        
        let error = pusher.lastError as? NSError;
        if (error != syncError) {
            syncError = error
            if let errorCode = error?.code {
                NSLog("Replication Error: \(error!)")
                if errorCode == 401 {
                    print("login failed.")
//                    Ui.showMessageDialog(
//                        onController: self.window!.rootViewController!,
//                        withTitle: "Authentication Error",
//                        withMessage:"Your username or password is not correct.",
//                        withError: nil,
//                        onClose: {
//                            self.logout()
//                    })
                }
                
            }
        }
        print("login success.")
    }

    
}
