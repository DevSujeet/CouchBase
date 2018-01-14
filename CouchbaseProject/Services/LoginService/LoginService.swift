//
//  LoginService.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/12/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class LoginService:AuthenticatorProtocol {
    var delegate: AuthenticatorDelegate?
    
    func authenticate(user username: String, withPassword password: String) {
        print("try to login with the service!!")
        
        var authToken = [String:String]()
        authToken["bearerToken"] = "asdfasfasdfasdfaerr"
        
        self.delegate?.didFinishAuthenticating(with: true, withParams: authToken)
    }
    
    
}
