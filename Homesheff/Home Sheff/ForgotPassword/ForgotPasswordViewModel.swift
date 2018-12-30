//
//  ForgotPasswordViewModel.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 12/26/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class ForgotPasswordViewModel: NSObject {
    private let apiHandler = APIManager()
    func forgotPassword(envelop:Requestable, completion: @escaping (Bool) -> Void) {
        apiHandler.forgotPassword(requestEnvelop: envelop, completion: completion)
    }
    
    func forgotPasswordEnvelop(email: String) -> Requestable{
        let forgotPasswordPath = ServicePath.forgotPassword(email: email)
        let forgotPasswordEnvelop = ForgotPasswordEnvelop(pathType: forgotPasswordPath)
        return forgotPasswordEnvelop
    }
}
