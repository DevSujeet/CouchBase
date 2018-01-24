//
//  AskDataBaseManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/22/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class AskDataBaseManager: CouchDatabaseManager {
    
    override func create(request: ServiceRequest) {
        let document = database.document(withID: (request.pathArgs?.documentID)!)
        let properties = request.pathArgs?.dataProp
        
        let onCreateResult = Response(withRequest: request)
        do {
            try document?.putProperties(properties!)
            onCreateResult.success = true
            onCreateResult.result = request.pathArgs?.documentID    //the id of the object created
        } catch(let error) {
            onCreateResult.success = false
            onCreateResult.error = error
            print("error in creation = \(error)")
        }
        
        self.dataBaseResponseListener.onCreate(result:onCreateResult)
    }
    
    override func read(id: String) {
        
    }
    
    override func update(request: ServiceRequest) {
        
    }
    
    override func delete(id: String) {
        
    }
    
    override func monitor(id: String) {
        print("monitored ID ie name = \(id)")
        self.monitorMapBlock = {(doc,emit) in
            if let query = doc["query"] {
                if let queryObject = Mapper<Query>().map(JSONObject:query) {
                    if let docId = queryObject.id {
                        print("emitting docId = \(docId)")
                        emit(docId,doc)
                    }
                }
            }
        }
    }
    
    override func listen() {
        self.listenMapBlock = {(doc,emit) in
            if let type = doc["type"] as? String ,type == "ask" {
                emit(type,doc)
            }
        }
    }
}
