//
//  RequestManagerFactory.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class  RequestManagerFactory
{
    static func getRequestManager(request:ServiceRequest) ->IRequestManager {
        //based on some paramenter...return couch or httpmanager
       let requestType = request.requestType! 
            switch requestType {
            case .HTTP:
                let httpManager = HTTPRequestManager()
                return httpManager
            case .CBL:
                let CBRequestManager = CouchBaseRequestManager.getInstance()
                return CBRequestManager
            }
        
   
    }
}


