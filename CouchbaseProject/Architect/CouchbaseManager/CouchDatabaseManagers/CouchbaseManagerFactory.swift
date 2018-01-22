//
//  CouchbaseManagerFactory.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/22/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class CouchbaseManagerFactory {
    
    func getCouchBaseDataManager(request:ServiceRequest,dataBaseResponseListener: IDataBaseResponseListner) -> DatabaseManagerProtocol {
        let requestPath = request.path!
        
        switch requestPath {

        case .ask:
            let askDatabaseManager = AskDataBaseManager(withRequest: request,
                                                        dataBaseResponseListener: dataBaseResponseListener)
            return askDatabaseManager
        case .track:
            let trackDatabaseManager = TrackDataBaseManager(withRequest: request,
                                                        dataBaseResponseListener: dataBaseResponseListener)
            return trackDatabaseManager
        case .alert:
            let alertDatabaseManager = AlertDataBaseManager(withRequest: request,
                                                        dataBaseResponseListener: dataBaseResponseListener)
            return alertDatabaseManager
        }
    }
}
