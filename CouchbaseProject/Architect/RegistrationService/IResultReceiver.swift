//
//  IResultReceiver.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/19/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

protocol IResultReciever {
    func onStart(result:Response)
    func onCreate(result:Response)
    func onChange(result:Response)
    func onListen(result:Response)
    func onError(result:Response)
    func onFinished(result:Response)
}
