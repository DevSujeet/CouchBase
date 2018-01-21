//
//  ResponseListenerRegistrationService.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/18/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class ResponseListenerRegistrationService : IResultReciever {

    var responseListeners:[String:IResponseListener]
    
    private init() {
        responseListeners = [:]
    }
        
    class var shared:ResponseListenerRegistrationService {
        struct singletonWrapper {
            static let singleton = ResponseListenerRegistrationService()
        }
        return singletonWrapper.singleton
    }
    
    private func register(requestPath:RequestPath,responseListener:IResponseListener){
        //what will be the key to register
        //---most likely, response path will be the key
        responseListeners[requestPath.path] = responseListener
    }
    
    private func deRegister(requestPath:RequestPath,responseListener:IResponseListener){
        responseListeners[requestPath.path] = nil
    }
    
    func start(requestPath:RequestPath,responseListner:IResponseListener){
        //first register the responseListener.
        self.register(requestPath: requestPath, responseListener: responseListner)
        //get Requestmanager from factory
        let requestManager = RequestManagerFactory.getRequestManager(requestPath: requestPath)
        
        requestManager.start(with: requestPath, resultReciever: self)
    }
    
    func stop(requestPath:RequestPath,responseListner:IResponseListener){
        //first register the
        self.deRegister(requestPath: requestPath, responseListener: responseListner)
        
        //get Requestmanager from factory
        let requestManager = RequestManagerFactory.getRequestManager(requestPath: requestPath)
        
        requestManager.stop(with: requestPath)
    }
    
    //MARK:- IResultReciever
    func onStart(result:Result){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onStart(result: result)
    }
    
    func onChange(result:Result){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onChange(result: result)
    }
    
    func onError(result:Result){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onError(result: result)
    }
    
    func onFinished(result:Result){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onFinished(result: result)
    }
}

