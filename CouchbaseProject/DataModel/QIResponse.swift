//
//  QIResponse.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//
/*
 {
 “id”: “8",
 “correlationId”: “b4lfCluX1xyZKeIxhJQ1Myeg1LSro5yF1GUp8OVs_No = “,
 “originalQuery”: “which of the service segments are away from the % sales achieved for region 901 “,
 “resolvedQuery”: “which of the service segments are away from the % sales achieved for region 901 “,
 “intentType”: “what “,
 “linguisticProperties”: {
 “tense”: “present”,
 “sentiment”: “neutral”,
 “person”: “null”,
 “typeOfQuestion”: “which”
 },
 “parameters”: [{
 “entities”: “Region 901",
 “filter”: null,
 “type”: “Employee”
 }, {
 “entities”: “Region”,
 “filter”: null,
 “type”: “Attribute”
 }, {
 “entities”: “ServiceLine”,
 “filter”: null,
 “type”: “Attribute”
 }, {
 “entities”: “A01 - 137560”,
 “filter”: null,
 “type”: “Customer”
 }, {
 “entities”: 901,
 “filter”: null,
 “type”: “Region”
 }, {
 “entities”: “SalesByCustSegFleetCount”,
 “filter”: null,
 “type”: “DerivedMetric”
 }],
 “contexts”: null,
 “properties”: {
 “userId”: “”,
 “location”: “”,
 “deviceType”: “”
 },
 “versionId”: “1.0”,
 “timestamp”: 1515481894209,
 “timeTaken”: “1.2999583859E10"
 }
 */
import Foundation
import ObjectMapper

enum Tense:String {
    case present
    case past
    case future
}

enum Sentiment:String {
    case neutral
    case positive
    case negative
}

class Person {
    
}

class QIResponse:mappableDataProtocol {
    var id:String?
    var correlationId:String?
    var originalQuery:String?
    var resolvedQuery:String?
    var intentType:String?
    var linguisticProperties:LinguisticProperties?
    var parameters:[QueryParameter]?
    var contexts:String?
    var properties:QueryProperty?
    var versionId:String?
    var timestamp:String?
    var timeTaken:String?
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "id: \(String(describing: id))\n, correlationId: \(String(describing:correlationId))\n, originalQuery: \(String(describing:originalQuery))\n, resolvedQuery: \(String(describing: resolvedQuery))\n, intentType: \(String(describing: intentType))\n, linguisticProperties: \(String(describing: linguisticProperties))\n, parameters: \(String(describing: parameters))\n, contexts: \(String(describing: contexts))\n, properties: \(String(describing: properties))\n, versionId: \(String(describing: versionId))\n, timestamp: \(String(describing: timestamp))\n, timeTaken: \(String(describing: timeTaken))\n"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        correlationId <- map["correlationId"]
        originalQuery <- map["originalQuery"]
        resolvedQuery <- map["resolvedQuery"]
        intentType <- map["intentType"]
        linguisticProperties <- map["linguisticProperties"]
        parameters <- map["parameters"]
        contexts <- map["contexts"]
        properties <- map["properties"]
        versionId <- map["versionId"]
        timestamp <- map["timestamp"]
        timeTaken <- map["timeTaken"]
    }
}

/*
 “linguisticProperties”: {
 “tense”: “present”,
 “sentiment”: “neutral”,
 “person”: “null”,
 “typeOfQuestion”: “which”
 }
 */
class LinguisticProperties:mappableDataProtocol {
    var tense:Tense?
    var sentiment:Sentiment?
    var person:Person?
    var typeOfQuestion:String?
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "tense: \(String(describing: tense)), sentiment: \(String(describing:sentiment))\n, person: \(String(describing:person))\n"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        tense <- map["tense"]
        sentiment <- map["sentiment"]
        person <- map["person"]
        typeOfQuestion <- map["typeOfQuestion"]
    }
}

/*
 “properties”: {
 “userId”: “”,
 “location”: “”,
 “deviceType”: “”
 }
 */
class QueryProperty:mappableDataProtocol {
    var userId:String?
    var location:String?
    var deviceType:String?
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "userId: \(String(describing: userId)), location: \(String(describing:location))\n, deviceType: \(String(describing:deviceType))\n"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        location <- map["location"]
        deviceType <- map["deviceType"]
    }
}
/*
 {
 “entities”: 901,
 “filter”: null,
 “type”: “Region”
 }
 */
class QueryParameter:mappableDataProtocol {
    var entities:[String]?
    var filter:String?
    var type:String?
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "entities: \(String(describing: entities)), filter: \(String(describing:filter))\n, type: \(String(describing:type))\n"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        entities <- map["entities"]
        filter <- map["filter"]
        type <- map["type"]
    }
}
