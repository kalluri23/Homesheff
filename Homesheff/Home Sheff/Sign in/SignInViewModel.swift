//
//  SignInViewModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

class SignInViewModel {
    let apiHandler = APIManager()
    func signInApi(envelop:Requestable, completion: @escaping (Bool) -> Void ) {
        apiHandler.signInApi(requestEnvelop: envelop, completion: completion)
    }
}
