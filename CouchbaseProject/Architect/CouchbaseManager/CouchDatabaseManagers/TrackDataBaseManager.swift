//
//  TrackDataBaseManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/22/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class TrackDataBaseManager: CouchDatabaseManager  {
    
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
    
    override func listen() {
        self.mapBlock = {(doc,emit) in
            if let email = doc["type"] as? String ,email == "sujeet@gmail.com" {
                emit(email,doc)
            }
        }
    }

    
}
