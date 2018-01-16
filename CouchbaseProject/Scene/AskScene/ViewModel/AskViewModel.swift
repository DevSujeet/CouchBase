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
class AskViewModel {
    var title:String?
    
    init(with title:String) {
        self.title = title
    }
}
