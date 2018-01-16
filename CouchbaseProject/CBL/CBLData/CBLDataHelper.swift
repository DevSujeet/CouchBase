//
//  CBLDataHelper.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/12/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

/*
    from original todo list
 "type": "task-list",
 "name": name,
 "owner": username
 */
import Foundation

let kLoginFlowEnabled = false
let kEncryptionEnabled = false
let kSyncEnabled = true
let kSyncGatewayUrl = URL(string: "http://52.191.193.71/cuddle")! //172.18.8.115 //127.0.0.1//52.191.193.71:5984
let kLoggingEnabled = false
let kUsePrebuiltDb = false
let kConflictResolution = false

class CBLDataHelper:NSObject {
    
    
    var database: CBLDatabase!
    var pusher: CBLReplication!
    var puller: CBLReplication!
    var syncError: NSError?
    var conflictsLiveQuery: CBLLiveQuery?
    var accessDocuments: Array<CBLDocument> = [];
    //channels on which the app/user is authorised to listen to changes.
    var userChannel:[String] = ["channel1","channel2","channel2"]
    
    //MARK:- init
    private override init() {
        super.init()
    }
    
    class var sharedCBLDataHelper:CBLDataHelper {
        struct SingleTonWrapper {
            static let singleton = CBLDataHelper()
        }
        return SingleTonWrapper.singleton
    }
    
    //MARK:- usage
    func startDB(with username:String, session:[String:String]){
        if kLoggingEnabled {
            enableLogging()
        }
        try! openDatabase(username: username, withKey: nil, withNewKey: nil)
        //before starting replication, verify the channels.
        startReplication(withSession: session)
    }
    

    // MARK: - Logging
    func enableLogging() {
        CBLManager.enableLogging("CBLDatabase")
        CBLManager.enableLogging("View")
        CBLManager.enableLogging("ViewVerbose")
        CBLManager.enableLogging("Query")
        CBLManager.enableLogging("Sync")
        CBLManager.enableLogging("SyncVerbose")
    }
    //MARK:-database creation
    func installPrebuiltDb(withName dbname:String) {
        // TRAINING: Install pre-built database
        guard kUsePrebuiltDb else {
            return
        }
        
        let db = CBLManager.sharedInstance().databaseExistsNamed(dbname)
        
        if (!db) {
            let dbPath = Bundle.main.path(forResource: dbname, ofType: "cblite2")
            do {
                try CBLManager.sharedInstance().replaceDatabaseNamed(dbname, withDatabaseDir: dbPath!)
            } catch let error as NSError {
                NSLog("Cannot replace the database %@", error)
            }
        }
    }
    
    func openDatabase(username:String, withKey key:String?,
                      withNewKey newKey:String?) throws {
        // TRAINING: Create a database
        let dbname = username
        let options = CBLDatabaseOptions()
        options.create = true
        
        if kEncryptionEnabled {
            if let encryptionKey = key {
                options.encryptionKey = encryptionKey
            }
        }
        
        try database = CBLManager.sharedInstance().openDatabaseNamed(dbname, with: options)
        if newKey != nil {
            try database.changeEncryptionKey(newKey)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(CBLDataHelper.observeDatabaseChange), name:Notification.Name.cblDatabaseChange, object: database)
    }
    
    @objc func observeDatabaseChange(notification: Notification) {
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
            NotificationCenter.default.addObserver(self, selector: #selector(CBLDataHelper.handleAccessChange), name: NSNotification.Name.cblDocumentChange, object: changedDoc);
        }
    }
    
    @objc func handleAccessChange(notification: Notification) throws {
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
    
    func closeDatabase() throws {
        stopConflictLiveQuery()
        try database.close()
    }
    
    func logout() {
        stopReplication()
        do {
            try closeDatabase()
        } catch let error as NSError {
            NSLog("Cannot close database: %@", error)
        }
//        let oldUsername = Session.username
//        Session.username = nil
//        login(username: oldUsername)
    }
    
    //MARK:- Handling login
//    func processLogin(controller: UIViewController, withUsername username: String,
//                      withPassword password: String, withNewPassword newPassword: String? = nil) {
//        do {
//            try startSession(username: username, withPassword: password,
//                             withNewPassword: newPassword)
//        } catch let error as NSError {
//            if error.code == 401 {
//                handleEncryptionError(controller: controller, withUsername: username,
//                                      withPassword: password)
//            } else {
//                Ui.showMessageDialog(
//                    onController: controller,
//                    withTitle: "Error",
//                    withMessage: "Login has an error occurred, code = \(error.code).")
//                NSLog("Cannot start a session: %@", error)
//            }
//        }
//    }
    
//    func handleEncryptionError(controller: UIViewController, withUsername username: String,
//                               withPassword password: String) {
//        Ui.showEncryptionErrorDialog(
//            onController: controller,
//            onMigrateAction: { oldPassword in
//                self.processLogin(controller: controller, withUsername: username,
//                                  withPassword: oldPassword, withNewPassword: password)
//        },
//            onDeleteAction: {
//                // Delete database:
//                self.deleteDatabase(dbName: username)
//                // login:
//                self.processLogin(controller: controller, withUsername: username,
//                                  withPassword: password)
//        }
//        )
//    }
    
    func deleteDatabase(dbName: String) {
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
    
    // MARK: - Replication
    
    func startReplication(withUsername username:String, andPassword password:String? = "") {
        guard kSyncEnabled else {
            return
        }
        syncError = nil
        
        // TRAINING: Start push/pull replications
        pusher = database.createPushReplication(kSyncGatewayUrl)
        pusher.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller = database.createPullReplication(kSyncGatewayUrl)
        //        puller.channels = ["username" + "-" + "task-list"]
        puller.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: puller)
        
        if kLoginFlowEnabled {
            let authenticator = CBLAuthenticator.basicAuthenticator(withName: username, password: password!)
            pusher.authenticator = authenticator
            puller.authenticator = authenticator
        }
        
        pusher.start()
        puller.start()
    }
    
    /*
     let session: Dictionary<String, String> = [
     "session_id": "904ac010862f37c8dd99015a33ab5a3565fd8447",
     "expires": "2015-09-23T17:27:17.555065803+01:00",
     "cookie_name": "SyncGatewaySession"
     ]
     */
    
    func startReplication(withSession session:[String:String]) {
        guard kSyncEnabled else {
            return
        }
        syncError = nil
        
        let dateString = session["expires"]!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)!

        
        // TRAINING: Start push/pull replications
        pusher = database.createPushReplication(kSyncGatewayUrl)
        pusher.setCookieNamed(session["cookie_name"]!, withValue: session["session_id"]!, path: "/", expirationDate: date, secure: false)
        pusher.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller = database.createPullReplication(kSyncGatewayUrl)
        puller.channels = self.userChannel
        puller.setCookieNamed(session["cookie_name"]!, withValue: session["session_id"]!, path: "/", expirationDate: date, secure: false)
        puller.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: puller)
        
//        if kLoginFlowEnabled {
//            let authenticator = CBLAuthenticator.basicAuthenticator(withName: username, password: password!)
//            pusher.authenticator = authenticator
//            puller.authenticator = authenticator
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
        let appDelegate = UIApplication.shared.delegate
        let error = pusher.lastError as? NSError;
        if (error != syncError) {
            syncError = error
            if let errorCode = error?.code {
                NSLog("Replication Error: \(error!)")
                if errorCode == 401 {
                    Ui.showMessageDialog(
                        onController: (appDelegate?.window!?.rootViewController!)!,
                        withTitle: "Authentication Error",
                        withMessage:"Your username or password is not correct.",
                        withError: nil,
                        onClose: {
                            self.logout()
                    })
                }
            }
        }
    }
    
    // MARK: - Conflicts Resolution
    
    // TRAINING: Responding to Live Query changes
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == conflictsLiveQuery {
            resolveConflicts()
        }
    }
    
    func startConflictLiveQuery() {
        guard kConflictResolution else {
            return
        }
        
        // TRAINING: Detecting when conflicts occur
        conflictsLiveQuery = database.createAllDocumentsQuery().asLive()
        conflictsLiveQuery!.allDocsMode = .onlyConflicts
        conflictsLiveQuery!.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        conflictsLiveQuery!.start()
    }
    
    func stopConflictLiveQuery() {
        conflictsLiveQuery?.removeObserver(self, forKeyPath: "rows")
        conflictsLiveQuery?.stop()
        conflictsLiveQuery = nil
    }
    
    func resolveConflicts() {
        let rows = conflictsLiveQuery?.rows
        while let row = rows?.nextRow() {
            if let revs = row.conflictingRevisions, revs.count > 1 {
                let defaultWinning = revs[0]
                let type = (defaultWinning["type"] as? String) ?? ""
                switch type {
                // TRAINING: Automatic conflict resolution
                case "task-list", "task-list.user":
                    let props = defaultWinning.userProperties
                    let image = defaultWinning.attachmentNamed("image")
                    resolveConflicts(revisions: revs, withProps: props, andImage: image)
                // TRAINING: N-way merge conflict resolution
                case "task":
                    let merged = nWayMergeConflicts(revs: revs)
                    resolveConflicts(revisions: revs, withProps: merged.props, andImage: merged.image)
                default:
                    break
                }
            }
        }
    }
    
    func resolveConflicts(revisions revs: [CBLRevision], withProps desiredProps: [String: Any]?,
                          andImage desiredImage: CBLAttachment?) {
        database.inTransaction {
            var i = 0
            for rev in revs as! [CBLSavedRevision] {
                let newRev = rev.createRevision()  // Create new revision
                if (i == 0) { // That's the current / winning revision
                    
                    
                    newRev.userProperties = desiredProps // Set properties to desired properties
                    if rev.attachmentNamed("image") != desiredImage {
                        newRev.setAttachmentNamed("image", withContentType: "image/jpg",
                                                  content: desiredImage?.content)
                    }
                } else {
                    // That's a conflicting revision, delete it
                    newRev.isDeletion = true
                }
                
                do {
                    try newRev.saveAllowingConflict()  // Persist the new revisions
                } catch let error as NSError {
                    NSLog("Cannot resolve conflicts with error: %@", error)
                    return false
                }
                i += 1
            }
            return true
        }
    }
    
    func nWayMergeConflicts(revs: [CBLRevision]) ->
        (props: [String: Any]?, image: CBLAttachment?) {
            guard let parent = findCommonParent(revisions: revs) else {
                let defaultWinning = revs[0]
                let props = defaultWinning.userProperties
                let image = defaultWinning.attachmentNamed("image")
                return (props, image)
            }
            
            var mergedProps = parent.userProperties ?? [:]
            var mergedImage = parent.attachmentNamed("image")
            var gotTask = false, gotComplete = false, gotImage = false
            for rev in revs {
                if let props = rev.userProperties {
                    if !gotTask {
                        let task = props["task"] as? String
                        if task != mergedProps["task"] as? String {
                            mergedProps["task"] = task
                            gotTask = true
                        }
                    }
                    
                    if !gotComplete {
                        let complete = props["complete"] as? Bool
                        if complete != mergedProps["complete"] as? Bool {
                            mergedProps["complete"] = complete
                            gotComplete = true
                        }
                    }
                }
                
                if !gotImage {
                    let attachment = rev.attachmentNamed("image")
                    let attachmentDiggest = attachment?.metadata["digest"] as? String
                    if (attachmentDiggest != mergedImage?.metadata["digest"] as? String) {
                        mergedImage = attachment
                        gotImage = true
                    }
                }
                
                if gotTask && gotComplete && gotImage {
                    break
                }
            }
            return (mergedProps, mergedImage)
    }
    
    func findCommonParent(revisions: [CBLRevision]) -> CBLRevision? {
        var minHistoryCount = 0
        var histories : [[CBLRevision]] = []
        for rev in revisions {
            let history = (try? rev.getHistory()) ?? []
            histories.append(history)
            minHistoryCount =
                minHistoryCount > 0 ? min(minHistoryCount, history.count) : history.count
        }
        
        if minHistoryCount == 0 {
            return nil
        }
        
        var commonParent : CBLRevision? = nil
        for i in 0...minHistoryCount {
            var rev: CBLRevision? = nil
            for history in histories {
                if rev == nil {
                    rev = history[i]
                } else if rev!.revisionID != history[i].revisionID {
                    rev = nil
                    break
                }
            }
            if rev == nil {
                break
            }
            commonParent = rev
        }
        
        if let deleted = commonParent?.isDeletion , deleted {
            commonParent = nil
        }
        return commonParent
    }
}
