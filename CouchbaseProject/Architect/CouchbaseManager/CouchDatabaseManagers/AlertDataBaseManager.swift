//
//  AlertDataBaseManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/22/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class AlertDataBaseManager: CouchDatabaseManager  {
    
    override func create(request: ServiceRequest) {
        
    }
    
    override func read(id: String) {
        
    }
    
    override func update(request: ServiceRequest) {
        
    }
    
    override func delete(id: String) {
        
    }
    
    override func monitor(id: String) {
        
    }
    
    
    /// create and listen to all changes on the view.
    override func listen() {
        self.listenMapBlock = {(doc,emit) in
            if let email = doc["type"] as? String ,email == "task-list" {
                emit(email,doc)
            }
        }
    }
    
}
