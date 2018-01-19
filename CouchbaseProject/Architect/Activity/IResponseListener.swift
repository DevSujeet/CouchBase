//
//  IResponseListener.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/18/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

protocol IResponseListener {
    func onStart(result:Result)
    func onChange(result:Result)
    func onError(result:Result)
    func onFinished(result:Result)
}
