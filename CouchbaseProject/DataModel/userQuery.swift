//
//  userQuery.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

/*
 var data = {
 "user": {
 "name": "",
 "email": "",
 "created": "timestamp"
 },
 "query": {
 "query": this.state.input,
 "userId": "abc@abc.com",
 "location": "",
 "deviceType": "",
 "_id": new Date().toISOString()
 }
 "_id": ""
 }
 */
import Foundation
import ObjectMapper

protocol mappableDataProtocol: Mappable, CustomStringConvertible {
    
}

class UserQuery:mappableDataProtocol {
    var id:String?  //id to be userid+currentdate
    var user:User?
    var query:Query?
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "Id: \(String(describing: id)), user: \(String(describing:user))\n, query: \(String(describing:query))\n"
    }
    
    required init?(map: Map) {

    }
        
    func mapping(map: Map) {
        id <- map["id"]
        user <- map["user"]
        query <- map["query"]
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
