//
//  EditServiceViewModel.swift
//  Homesheff
//
//  Created by Anurag Pandey on 1/22/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

class EditServiceViewModel {
    
    private let apiHandler = APIManager()
    
    //MARK: - EditService API
    func editService(envelop:Requestable, completion: @escaping (Bool?) -> Void) {
        apiHandler.editServiceApi(requestEnvelop: envelop) { (success) in
            completion(success)
        }
    }
    
    //MARK: - EditService API
    func deleteService(envelop:Requestable, completion: @escaping (Bool?) -> Void) {
        apiHandler.deleteServiceApi(requestEnvelop: envelop) { (success) in
            completion(success)
        }
    }
    
    func editServiceEnvelop(name: String, description: String?, serviceId: String) -> Requestable {
        let editServicePath = ServicePath.editService(name: name, description: description, serviceId: serviceId)
        let editServiceEnvelop = EditServiceEnvelop(pathType: editServicePath)
        return editServiceEnvelop
    }
    
    func deleteServiceEnvelop(serviceId: String) -> Requestable {
        let deleteServicePath = ServicePath.deleteService(serviceId: serviceId)
        let deleteServiceEnvelop = DeleteServiceEnvelop(pathType: deleteServicePath)
        return deleteServiceEnvelop
    }
}
