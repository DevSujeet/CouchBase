//
//  AskModel.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/22/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
import ObjectMapper
//{"name": "Test","owner": "usertest","type": "ask", "email": "sujeet@gmail.com"}

class AskModel:Mappable,CustomStringConvertible {

    var name:String? = "sujeetQuestion"
    var owner:String? = "sujeetAnswer"
    var type:String? = "task-list"
    var email:String? = "sujeet@gmail.com"
    
    //MARK:- object Mapper and default initializer methods
    var description: String {
        return "name: \(String(describing: name)), owner: \(String(describing:owner))\n, type: \(String(describing:type))\n, email: \(String(describing:email))\n"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        owner <- map["owner"]
        type <- map["type"]
        email <- map["email"]
    }
}
