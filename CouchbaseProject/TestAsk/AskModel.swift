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

class AskModel:Mappable {

    var name:String? = "sujeetQuestion"
    var owner:String? = "sujeetAnswer"
    var type:String? = "task-list"
    var email:String? = "sujeet@gmail.com"
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        owner <- map["owner"]
        type <- map["type"]
        email <- map["email"]
    }
}
