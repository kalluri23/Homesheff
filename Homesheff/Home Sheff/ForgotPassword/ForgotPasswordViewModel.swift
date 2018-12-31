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
    
    //MARK: - ForgotPassword API
    func forgotPassword(envelop:Requestable, completion: @escaping (Bool) -> Void) {
        apiHandler.forgotPasswordApi(requestEnvelop: envelop, completion: completion)
    }
    
    func forgotPasswordEnvelop(email: String) -> Requestable{
        let forgotPasswordPath = ServicePath.forgotPassword(email: email)
        let forgotPasswordEnvelop = ForgotPasswordEnvelop(pathType: forgotPasswordPath)
        return forgotPasswordEnvelop
    }
    
    //MARK: - Validate Code API
    func validateCode(envelop:Requestable, completion: @escaping (Bool) -> Void) {
        apiHandler.validateCodeApi(requestEnvelop: envelop, completion: completion)
    }
    
    func validateCodeEnvelop(email: String, code:String) -> Requestable{
        let validateCodePath = ServicePath.validate(email: email, code: code)
        let validateCodeEnvelop = ValidateCodeEnvelop(pathType: validateCodePath)
        return validateCodeEnvelop
    }
    
    //MARK: - Reset Password API
    func resetPassword(envelop:Requestable, completion: @escaping (Bool) -> Void) {
        apiHandler.resetPasswordApi(requestEnvelop: envelop, completion: completion)
    }
    
    func resetPasswordEnvelop(email: String, code: String, password:String) -> Requestable{
        let resetPasswordPath = ServicePath.resetPassword(email: email, code: code, password: password)
        let resetPasswordEnvelop = ResetPasswordEnvelop(pathType: resetPasswordPath)
        return resetPasswordEnvelop
    }
}
