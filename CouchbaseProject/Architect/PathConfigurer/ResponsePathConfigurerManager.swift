//
//  ResponsePathConfigurerManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/18/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

enum RequestType:String {
    case HTTP
    case CBL
}

enum BaseOperation:String {
    case create
    case read
    case update
    case delete
    
    case monitor
    case listen
}

enum PathNames:String {
    case ask
    case track
    case alert
}

class RequestPathArgs { //create builder patter for this class
    
    var documentID:String?
    var selectArgs:[String]?
    var sortOrder:String?
    var sortBy:[String]?
    var operationType:BaseOperation?
    var dataProp:[String:Any]?

    init(with documentID:String?, selectArgs:[String]?,sortOrder:String?,sortBy:[String]?,operationType:BaseOperation?,dataProp:[String:Any]?) {
        
        self.documentID = documentID
        self.selectArgs = selectArgs
        self.sortOrder = sortOrder
        self.sortBy = sortBy
        self.operationType = operationType
        self.dataProp = dataProp
    }
}

class RequestPathArgsBuilder {
    private var documentID:String?
    private var selectArgs:[String]?
    private var sortOrder:String?
    private var sortBy:[String]?
    private var operationType:BaseOperation?
    private var dataProp:[String:Any]?
    
    func setDocoumentId(documentID:String?){
        self.documentID = documentID
    }
    
    func setSelectArgs(selectArgs:[String]?){
        self.selectArgs = selectArgs
    }
    
    func setSortOrder(sortOrder:String?){
        self.sortOrder = sortOrder
    }
    
    func setSortBy(sortBy:[String]?){
        self.sortBy = sortBy
    }
    
    func setOperationType(operationType:BaseOperation?){
        self.operationType = operationType
    }
    
    func setDataProp(dataProp:[String:Any]?) {
        self.dataProp = dataProp
    }
    
    func buildPathArgs()->RequestPathArgs {
        return RequestPathArgs(with: documentID, selectArgs: selectArgs, sortOrder: sortOrder, sortBy: sortBy, operationType: operationType, dataProp: dataProp)
    }
}

class ServiceRequest {
    var path:PathNames?
    var pathArgs:RequestPathArgs?
    var requestType:RequestType?
    
    init(with path:PathNames, pathArgs:RequestPathArgs, requestType:RequestType) {
        self.path = path
        self.pathArgs = pathArgs
        self.requestType = requestType
    }
}

//class CBLRequestPath:ServiceRequest {
//    var mapBlock:CBLMapBlock!
//}

class ResponsePathConfigurerManager {
    class func configure(requestPathConfigurer:IResponsePathConfigurer) -> ServiceRequest {
        var serviceRequest:ServiceRequest?
        
        serviceRequest = ServiceRequest(with: requestPathConfigurer.getResponseListenerPath(), pathArgs: requestPathConfigurer.getResponseListenerPathArgs(),requestType:requestPathConfigurer.getRequestType())
        
        return serviceRequest!
    }
}


protocol IResponsePathConfigurer {
    func getResponseListenerPath() ->PathNames
    func getResponseListenerPathArgs() -> RequestPathArgs
    func getRequestType() ->RequestType
}
