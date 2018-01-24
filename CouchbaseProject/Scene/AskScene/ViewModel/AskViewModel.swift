//
//  AskViewModel.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/16/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

//this class is to seperate the data model from the actual data, eg the CBLQUery from couchbase or some json from a service.
// any kind of actual data will be mapped to this view model so that the view is independent from the source data struct changes or vice versa.

/*
 {
 "name": "Test",
 "owner": "usertest",
 "type": "task-list"
 }
 */

class AskViewModel {
    var title:String?
    var owner:String?
    var type:String?
    var userQuery:UserQuery?
    
    init(with title:String,owner:String,type:String) {
        self.title = title
        self.owner = owner
        self.type = type
    }
    
    init(withQuery query:UserQuery) {
        self.userQuery = query
    }
}

protocol askModelAdapter {
    func getAskModel() -> AskViewModel
    func getAskModelArray() -> [AskViewModel]
}

class CBLQuesyAskAdapter:askModelAdapter {
    func getAskModel() -> AskViewModel {
        let ask1 = AskViewModel(with: "ask1", owner: "test", type: "type")
        return ask1
    }
    
    func getAskModelArray() -> [AskViewModel] {
        let ask1 = AskViewModel(with: "ask1", owner: "test", type: "type")
        return [ask1]
    }
}
