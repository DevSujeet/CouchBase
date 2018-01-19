//
//  IResultReceiver.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

protocol IResultReciever {
    func onStart(result:Result)
    func onChange(result:Result)
    func onError(result:Result)
    func onFinished(result:Result)
}
