//
//  AuthenticatorProtocol.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/12/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
enum AuthenticatorType{
    case couchbase
    case service
}

class AuthenticatorFactory {
    
    func getAuthenticator(forType type:AuthenticatorType) -> AuthenticatorProtocol {
        var authenticator:AuthenticatorProtocol?
        switch type {
        case .couchbase:
            authenticator = LoginWithReplicationSerivice()
        case .service:
            authenticator = LoginService()

        }
        return authenticator!
    }
}

protocol AuthenticatorDelegate:NSObjectProtocol {
    func didFinishAuthenticating(with status:Bool,withParams:[String:String])
}

protocol AuthenticatorProtocol {
    weak var delegate:AuthenticatorDelegate? {get set}
    func authenticate(user username:String, withPassword password:String)
}
