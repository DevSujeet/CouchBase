//
//  ResponsePathConfigurerManager.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/18/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class RequestPath {
    var path:String
    var pathArgs:[String:Any]
    
    init(withPath path:String ,pathArgs:[String:Any] ) {
        self.path = path
        self.pathArgs = pathArgs
    }
}

class ResponsePathConfigurerManager {
    class func configure(requestPathConfigurer:IResponsePathConfigurer) -> RequestPath {
        let requestPath = RequestPath(withPath: requestPathConfigurer.getResponseListenerPath()!, pathArgs: requestPathConfigurer.getResponseListenerPathArgs()!)
        return requestPath
    }
}


protocol IResponsePathConfigurer {
    func getResponseListenerPath() ->String?
    func getResponseListenerPathArgs() -> [String:Any]?
}
