//
//  userQuery.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

/*
 {
 "query": {
 "_id": "2018-01-12T15:01:02.689Z",
 "deviceType": "",
 "location": "",
 "query": "Sales of silk",
 "userId": "abc@abc.com"
 },
 "reponse": {
 "contexts": null,
 "correlationId": "b4lfCluX1xyZKeIxhJQ1Myeg1LSro5yF1GUp8OVs_No = ",
 "id": "8",
 "intentType": "what ",
 "linguisticProperties": {
 "person": "null",
 "sentiment": "neutral",
 "tense": "present",
 "typeOfQuestion": "which"
 },
 "originalQuery": "which of the service segments are away from the % sales achieved for region 901 ",
 "parameters": [{
 "entities": "Region 901",
 "filter": null,
 "type": "Employee"
 },
 {
 "entities": "Region",
 "filter": null,
 "type": "Attribute"
 },
 {
 "entities": "ServiceLine",
 "filter": null,
 "type": "Attribute"
 },
 {
 "entities": "A01 - 137560",
 "filter": null,
 "type": "Customer"
 },
 {
 "entities": 901,
 "filter": null,
 "type": "Region"
 },
 {
 "entities": "SalesByCustSegFleetCount",
 "filter": null,
 "type": "DerivedMetric"
 }
 ],
 "properties": {
 "deviceType": "",
 "location": "",
 "userId": ""
 },
 "resolvedQuery": "which of the service segments are away from the % sales achieved for region 901 ",
 "timeTaken": "1.2999583859E10",
 "timestamp": 1515481894209,
 "versionId": "1.0"
 },
 "user": {
 "created": "timestamp",
 "email": "",
 "name": ""
 }
 }
 */
import Foundation
import ObjectMapper

protocol mappableDataProtocol: Mappable, CustomStringConvertible {
    
}

class UserQuery:mappableDataProtocol {
    var query:Query?
    var user:User?
    var response:[QIResponse]?
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "user: \(String(describing:user))\n, query: \(String(describing:query))\n, response: \(String(describing:response))\n"
    }
    
    required init?(map: Map) {

    }
        
    func mapping(map: Map) {
        user <- map["user"]
        if user == nil {
            user = User(JSON: [:])
        }
        
        query <- map["query"]
        if query == nil {
            query = Query(JSON: [:])
        }
        response <- map["response"]
    }
}

class User:mappableDataProtocol{
    var name:String?
    var email:String?
    var created:Date?
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "name: \(String(describing: name)), email: \(String(describing:email))\n, created: \(String(describing:created))\n"
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        created <- (map["created"], MillisecondsToDateTransform())
    }
}


class Query:mappableDataProtocol{
    var query:String?
    var userId:String?
    var location:String?
    var deviceType:String?
    var id:String?  //mapped to the userquery id
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "query: \(String(describing: query)), userId: \(String(describing:userId))\n, location: \(String(describing:location))\n, deviceType: \(String(describing:deviceType))\n, id: \(String(describing:id))\n"
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        query <- map["query"]
        userId <- map["userId"]
        location <- map["location"]
        deviceType <- map["deviceType"]
        id <- map["id"]
    }
}
