//
//  MillisecondsToDateTransform.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class MillisecondsToDateTransform: TransformType {
    typealias Object = Date
    typealias JSON = Int64
    
    init() {
    }
    
    func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInMilliseconds = value as? CLongLong {
            return Utility.toDate(timeInMilliseconds)
        }
        
        return nil
    }
    
    func transformToJSON(_ value: Date?) -> Int64? {
        return Utility.toTimeInMilliseconds(value)
    }
}

