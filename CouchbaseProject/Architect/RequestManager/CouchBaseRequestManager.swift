//
//  CouchBaseRequestManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation


final class CouchBaseRequestManager:IRequestManager,IDataBaseResponseListner {
    
    var dataBases:[String:DatabaseManagerProtocol]?
    
    class func getInstance() -> CouchBaseRequestManager {
        return shared
    }
    
    private init() {
        dataBases = [:]
        
        }
        
    class var shared:CouchBaseRequestManager {
        struct singletonWrapper {
            static let singleton = CouchBaseRequestManager()
        }
        return singletonWrapper.singleton
    }

    //MARK:- IRequestManager
    var iResultReciever: IResultReciever?
    
    func start(with request: ServiceRequest, resultReciever: IResultReciever) {
        
        iResultReciever = resultReciever
        if let dataBaseManager = dataBases![(request.path?.rawValue)!] {
            dataBaseManager.update(serviceRequest: request)
             dataBaseManager.execute()
        } else {
            //create a new instance of DataBaseManager
            let dataBaseManager = CouchbaseManagerFactory().getCouchBaseDataManager(request: request, dataBaseResponseListener: self)
            //add in the dictionary
            dataBases![(request.path?.rawValue)!] = dataBaseManager
            //execute on data base
            dataBaseManager.update(serviceRequest: request)
            dataBaseManager.execute()
        }
    }
    
    func stop(with request:ServiceRequest) {
        if let dataBaseManager = dataBases![(request.path?.rawValue)!] {
            dataBaseManager.stopListening()
        }
    }
    
    //MARK:- IDataBaseResponseListner
    //TODO:-  thread..lookout
    func onStart(result: Response) {
        iResultReciever?.onStart(result: result)
    }
    func onCreate(result:Response){
        iResultReciever?.onCreate(result: result)
    }
    func onListen(result:Response) {
        iResultReciever?.onListen(result: result)
    }
    
    func onChange(result: Response) {
        iResultReciever?.onChange(result: result)
    }
    
    func onError(result: Response) {
        iResultReciever?.onError(result: result)
    }
    
    func onFinished(result: Response) {
        iResultReciever?.onFinished(result: result)
    }
}
