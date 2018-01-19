//
//  IRequestManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

protocol IRequestManager {
    
    var iResultReciever:IResultReciever? {get set}
    
    func start(with responsePath:RequestPath, resultReciever:IResultReciever)
    
    func stop(with responsePath:RequestPath)
}


