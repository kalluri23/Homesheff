//
//  FinishYourProfileViewModel.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/3/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

protocol FinishYourProfileFieldsViewModelItem {
    var type: FinishYourProfileFieldItemType { get }
    var rowCount: Int { get }
}

class FinishYourProfileViewModel: NSObject {
    
    let fieldData = FinishYourProfileFields()
    var fields = [FinishYourProfileFieldsViewModelItem]()
    let apiHandler = APIManager()
    
    override init() {
        
        if  !fieldData.genericFields.isEmpty {
            let genericFields = FinishGenericFieldItem(genericData: fieldData.genericFields)
            fields.append(genericFields)
        }
        
        let selectedFields = SelectedServiceFieldItem(addserviceData:fieldData.service!)
            fields.append(selectedFields)
    }
    
    func finishUserProfile(envelop:Requestable, completion: @escaping (Bool) -> Void ) {
        apiHandler.updateUserPreferenceCall(requestEnvelop: envelop, completion: completion)
    }
    
    
}

class FinishGenericFieldItem: FinishYourProfileFieldsViewModelItem {
    
    var genericData: [GenericField]
    
    var type: FinishYourProfileFieldItemType {
        return .genericField
    }
    
    var rowCount: Int {
        return genericData.count
    }
    
    init(genericData: [GenericField]) {
        self.genericData = genericData
    }
}

class SelectedServiceFieldItem: FinishYourProfileFieldsViewModelItem {
    
    var addServices: AddServiceFields
    
    var type: FinishYourProfileFieldItemType {
        
        return .selectedServicesCollectionViewField
    }
    
    var rowCount: Int {
       return 1
    }
    
    init(addserviceData: AddServiceFields) {
        self.addServices = addserviceData
    }
}
