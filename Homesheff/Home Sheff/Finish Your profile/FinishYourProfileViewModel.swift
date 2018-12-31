//
//  FinishYourProfileViewModel.swift
//  Homesheff
//
//  Created by Anurag Pandey on 12/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

class FinishYourProfileViewModel {
    let apiHandler = APIManager()
    let profileFields = ["FIRST NAME", "LAST NAME", "HEADLINE", "ABOUT", "EMAIL", "LOCATION", "PHONE"]
    let title = "Finish Your Profile"
    var userEnteredData = [String: String]()
    
    func finishUserProfile(envelop:Requestable, completion: @escaping (Bool) -> Void ) {
        apiHandler.updateUserPreferenceCall(requestEnvelop: envelop, completion: completion)
    }
    
    func validateUserInput() -> Bool {
        if userEnteredData.count < profileFields.count {
            return false
        }
        return true
    }
    
    func getUserData(_ value: String) -> String {
        
        //Return the user entered value for fields if present
        if let userData = userEnteredData[value], userData != "" {
            return userData
        }
        
        //Fill the dafault values if user didn't enter enything yet
        switch value {
        case "FIRST NAME":
            let firstName = User.defaultUser.currentUser?.firstName ?? ""
            userEnteredData[value] = firstName
            return firstName
            
        case "LAST NAME":
            let lastName = User.defaultUser.currentUser?.lastName ?? ""
            userEnteredData[value] = lastName
            return lastName
            
        case "EMAIL":
            let email = User.defaultUser.currentUser?.email ?? ""
            userEnteredData[value] = email
            return email
            
        default:
            return userEnteredData[value] ?? ""
        }
    }
}
