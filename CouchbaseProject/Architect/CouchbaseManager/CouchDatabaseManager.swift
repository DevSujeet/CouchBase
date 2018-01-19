//
//  DatabaseManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

/*
 based on:-
 That each track/feed/alert/ will have there own instance of couchDB bucket.
 */
class CouchDatabaseManager  {
    
    var dataBaseResponseListener:IDataBaseResponseListner!  //acts as a delegate
    var requestPath:RequestPath!
    
    init(withRequestPath path:RequestPath, dataBaseResponseListener:IDataBaseResponseListner ) {
        self.requestPath = path
        self.dataBaseResponseListener = dataBaseResponseListener
    }
    
    init() {
        
    }
    
    func execute() {
        //call test method after few sec
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.test()
        }
    }
    
    //test method
    func test() {
        self.dataBaseResponseListener.onChange(result: Result(withPath: requestPath.path))
    }
    
}

