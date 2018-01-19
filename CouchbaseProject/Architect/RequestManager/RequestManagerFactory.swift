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
    static func getRequestManager(requestPath:RequestPath) ->IRequestManager {
        //based on some paramenter...return couch or httpmanager
        let testManager = CouchBaseRequestManager.getInstance()
        return testManager
    }
}


