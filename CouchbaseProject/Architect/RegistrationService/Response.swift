//
//  Result.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

/*
    class wraps the response from the database or HTTP
 contains result response, error, and the path(as the key that indentifys..who called for the service.)
 */
class Response {
    //that will determine which activity(Iresponselistner) called for the action.
    //as path is the key , get Iresponselistner from the dictionary
    var path:String!
    
    var request:ServiceRequest?
    var success:Bool? = false
    var result:Any?
    
    var error:Error?
    
    init(withPath path:String) {
        self.path = path
    }
}
