//
//  CouchBaseRequestManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation


final class CouchBaseRequestManager:IRequestManager,IDataBaseResponseListner {
    
    var dataBases:[String:CouchDatabaseManager]?
    
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
    
    func start(with responsePath: RequestPath, resultReciever: IResultReciever) {
        
        iResultReciever = resultReciever
        if let dataBaseManager = dataBases![responsePath.path] {
             dataBaseManager.execute()
        }else {
            //create a new instance of DataBaseManager
            let dataBaseManager = CouchDatabaseManager(withRequestPath: responsePath, dataBaseResponseListener: self)
            //add in the dictionary
            dataBases![responsePath.path] = dataBaseManager
            //execute on data base
            dataBaseManager.execute()
        }
    }
    
    func stop(with responsePath:RequestPath) {
        if let dataBaseManager = dataBases![responsePath.path] {
            dataBaseManager.stopListening()
        }
    }
    
    //MARK:- IDataBaseResponseListner
    //TODO:-  thread..lookout
    func onStart(result: Result) {
        iResultReciever?.onStart(result: result)
    }
    
    func onChange(result: Result) {
        iResultReciever?.onChange(result: result)
    }
    
    func onError(result: Result) {
        iResultReciever?.onError(result: result)
    }
    
    func onFinished(result: Result) {
        iResultReciever?.onFinished(result: result)
    }
}
