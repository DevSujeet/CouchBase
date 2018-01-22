//
//  AskDataBaseManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/22/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class AskDataBaseManager: CouchDatabaseManager {
    
    override func create(request: ServiceRequest) {
        let document = database.document(withID: (request.pathArgs?.documentID)!)
        
        let properties = request.pathArgs?.dataProp
        do {
            try document?.putProperties(properties!)
        } catch(let error) {
            print("error in creation = \(error)")
        }
        
            
        
    }
    
    override func read(id: String) {
        
    }
    
    override func update(request: ServiceRequest) {
        
    }
    
    override func delete(id: String) {
        
    }
    
    override func monitor(id: String) {
        self.mapBlock = {(doc,emit) in
            if let email = doc["type"] as? String ,email == "task" {
                emit(email,doc)
            }
        }
    }
    
    override func listen() {
        self.mapBlock = {(doc,emit) in
            if let email = doc["type"] as? String ,email == "task-list" {
                emit(email,doc)
            }
        }
    }
}
