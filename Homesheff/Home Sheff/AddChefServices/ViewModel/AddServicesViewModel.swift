//
//  AddServicesViewModel.swift
//  Homesheff
//
//  Created by Anurag Pandey on 1/21/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

class AddServicesViewModel {
    
    private let apiHandler = APIManager()
    
    //MARK: - GetService API
    func getServices(envelop:Requestable, completion: @escaping ([SheffService]?) -> Void) {
        apiHandler.getServicesApi(requestEnvelop: envelop) { (serviceList) in
            completion(serviceList)
        }
    }
    
    func getServicesEnvelop() -> Requestable {
        let userId = "\(User.defaultUser.currentUser?.id ?? 168)"
        let getServicesPath = ServicePath.getServices(userId: userId)
        let getServicesEnvelop = GetServicesEnvelop(pathType: getServicesPath)
        return getServicesEnvelop
    }
    
}
