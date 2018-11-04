//
//  UserProfileViewModel.swift
//  Homesheff
//
//  Created by Anurag Pandey on 11/3/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

class UserProfileViewModel {
    
    let apiHandler = APIManager()
    func updateUserProfile(envelop:Requestable, completion: @escaping (Bool) -> Void ) {
        apiHandler.updateUserPreferenceCall(requestEnvelop: envelop, completion: completion)
    }
    
}
