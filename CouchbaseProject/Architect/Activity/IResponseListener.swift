//
//  IResponseListener.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/18/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

protocol IResponseListener {
    func onStart(result:Response)
    func onCreate(result:Response)
    func onListen(result:Response)
    func onChange(result:Response)  //to listen to changes in a single doc.
    func onError(result:Response)
    func onFinished(result:Response)
}
