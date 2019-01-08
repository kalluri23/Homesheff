//
//  SignInViewModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

class SignInViewModel : NSObject{
    let apiHandler = APIManager()
    func signInApi(envelop:Requestable, completion: @escaping (Bool) -> Void ) {
        apiHandler.signInApi(requestEnvelop: envelop, completion: completion)
    }
    
    func autoSignIn(envelop:Requestable, completion: @escaping (Bool) -> Void) {
        apiHandler.getUserById(requestEnvelop: envelop, completion: completion)
    }
    
    func autoSignInEnvelop(userId: Int) -> Requestable {
        let searchPath = ServicePath.getUserById(userId: userId)
        let userEnvelop = GetUserById(pathType: searchPath)
        return userEnvelop
    }
    
    func signInEnvelop(userName: String, password: String) -> Requestable {
        
        let userListSearchPath = ServicePath.signInCall(userName: userName, password: password)
        let userListEnvelop = SignInEnvelop(pathType: userListSearchPath)
        
        return userListEnvelop
    }
}
