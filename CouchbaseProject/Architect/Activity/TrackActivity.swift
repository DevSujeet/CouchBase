//
//  TrackActivity.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/18/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation


protocol AbstractActivity:IResponseListener,IResponsePathConfigurer {
        
}

class TrackActivity:AbstractActivity {

    let responseListiner = ResponseListenerRegistrationService.shared
    
    //test method
    func getTrackInformation() {
        let requestPath = ResponsePathConfigurerManager.configure(requestPathConfigurer: self)
        responseListiner.start(requestPath: requestPath, responseListner: self)
    }
    
    
    //MARK:-IResponsePathConfigurer
    
    func getResponseListenerPath() -> String? {
        return "track"
    }
    
    func getResponseListenerPathArgs() -> [String : Any]? {
        return [:]
    }
    

    //MARK:- IResponseListener protocol
    func onStart(result: Result) {
        print("TrackActivity onStart")
    }
    
    func onChange(result: Result) {
        print("TrackActivity onChange")
        print(result.path)
    }
    
    func onError(result: Result) {
        print("TrackActivity onError")
    }
    
    func onFinished(result: Result) {
        print("TrackActivity onFinished")
    }

}
