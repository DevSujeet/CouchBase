//
//  TrackActivity.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/18/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation


protocol ResponseListenerProtocol:IResponseListener,IResponsePathConfigurer {
        
}

class TrackActivity:ResponseListenerProtocol {
    let responseListiner = ResponseListenerRegistrationService.shared
    
    //test method
    func getTrackInformation() {
        let requestPath = ResponsePathConfigurerManager.configure(requestPathConfigurer: self)
        
//        requestPath.mapBlock = {(doc,emit) in
//            
//            if let type = doc["type"] as? String ,type == "task-list" {
//                emit(type,doc)
//            }
//        }
        responseListiner.start(requestPath: requestPath, responseListner: self)
    }
    
    
    //MARK:-IResponsePathConfigurer
    
    func getResponseListenerPath() -> PathNames {
        return .ask
    }
    
    func getResponseListenerPathArgs() -> RequestPathArgs {
        return RequestPathArgs(with: nil, selectArgs: nil, sortOrder: nil, sortBy: nil, operationType: .listen, dataProp: nil)    //create a builder to create a specific requestPath.
    }
    
    func getRequestType() ->RequestType {
        return .HTTP
    }

    //MARK:- IResponseListener protocol
    func onStart(result: Response) {
        print("TrackActivity onStart")
    }
    func onCreate(result:Response){
        print("TrackActivity onCreate")
    }
    func onListen(result:Response) {
        print("TrackActivity onListen")
        print(result.path)
    }
    func onChange(result: Response) {
        print("TrackActivity onChange")
        print(result.path)
    }
    
    func onError(result: Response) {
        print("TrackActivity onError")
    }
    
    func onFinished(result: Response) {
        print("TrackActivity onFinished")
    }

}
