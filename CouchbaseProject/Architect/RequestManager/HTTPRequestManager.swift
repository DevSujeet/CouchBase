//
//  HTTPRequestManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

///some protocol as IDataBaseResponseListner is required.
class HTTPRequestManager:IRequestManager {
    
    var iResultReciever: IResultReciever?
    
    func start(with request: ServiceRequest, resultReciever: IResultReciever) {
        
    }
    
    func stop(with request:ServiceRequest) {
        
    }
}
