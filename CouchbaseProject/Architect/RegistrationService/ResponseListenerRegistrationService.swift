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
    
    private func register(requestPath:ServiceRequest,responseListener:IResponseListener){
        //what will be the key to register
        //---most likely, response path will be the key
        responseListeners[(requestPath.path?.rawValue)!] = responseListener
    }
    
    private func deRegister(requestPath:ServiceRequest,responseListener:IResponseListener){
        responseListeners[(requestPath.path?.rawValue)!] = nil
    }
    
    func start(requestPath:ServiceRequest,responseListner:IResponseListener){
        //first register the responseListener.
        self.register(requestPath: requestPath, responseListener: responseListner)
        //get Requestmanager from factory
        let requestManager = RequestManagerFactory.getRequestManager(request: requestPath)
        
        requestManager.start(with: requestPath, resultReciever: self)
    }
    
    func stop(requestPath:ServiceRequest,responseListner:IResponseListener){
        //first register the
        self.deRegister(requestPath: requestPath, responseListener: responseListner)
        
        //get Requestmanager from factory
        let requestManager = RequestManagerFactory.getRequestManager(request: requestPath)
        
        requestManager.stop(with: requestPath)
    }
    
    //MARK:- IResultReciever
    func onStart(result:Response){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onStart(result: result)
    }
    
    func onChange(result:Response){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onChange(result: result)
    }
    
    func onError(result:Response){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onError(result: result)
    }
    
    func onFinished(result:Response){
        //get the listener from the dictionary
        let responseListener = self.responseListeners[result.path]
        responseListener?.onFinished(result: result)
    }
}

