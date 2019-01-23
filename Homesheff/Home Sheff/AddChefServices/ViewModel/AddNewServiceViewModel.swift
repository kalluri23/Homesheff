//
//  AddNewServiceViewModel.swift
//  Homesheff
//
//  Created by Anurag Pandey on 1/21/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

class AddNewServiceViewModel {
    
    private let apiHandler = APIManager()
    
    //MARK: - AddService API
    func addService(envelop:Requestable, completion: @escaping (SheffService?) -> Void) {
        apiHandler.addServiceApi(requestEnvelop: envelop) { (service) in
            completion(service)
        }
    }
    
    func addServiceEnvelop(name: String, description: String?) -> Requestable {
        let addServicePath = ServicePath.addService(name: name, description: description, userPreferenceId: User.defaultUser.currentUser?.id ?? 0)
        let addServiceEnvelop = AddServiceEnvelop(pathType: addServicePath)
        return addServiceEnvelop
    }
    
}
