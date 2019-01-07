//
//  CreateAccountViewModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 9/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

protocol FieldsViewModelItem {
    var type: FieldItemType { get }
    var rowCount: Int { get }
}

class CreateAccountViewModel: NSObject {
    
    let fieldData = Fields()
    var fields = [FieldsViewModelItem]()
    let apiHandler = APIManager()
    
    func signUp(envelop:Requestable, completion: @escaping (Bool) -> Void ) {
        apiHandler.signUpCall(requestEnvelop: envelop, completion: completion)
    }
    
    func signUpEnvelop(_ basicDetails: Details) -> Requestable {
        let signupSearchPath = ServicePath.signUpCall(email: basicDetails.email, password: basicDetails.password, phoneNo: basicDetails.phoneNo, firstName: basicDetails.firstName, lastName: basicDetails.lastName, isChef: basicDetails.isChef, isCustomer: basicDetails.isCustomer, imageUrl: basicDetails.imageUrl, zipCode: basicDetails.zipCode)
        let signupEnvelop = SaveUserPreferencesEnvelop(pathType: signupSearchPath)
        return signupEnvelop
    }
    
    override init() {
        
        if  !fieldData.genericFields.isEmpty {
            let genericFields = GenericFieldItem(genericData: fieldData.genericFields)
            fields.append(genericFields)
        }
        
        if  !fieldData.categoryFields.isEmpty {
            let category = CategoryFieldItem(categoryFieldData: fieldData.categoryFields)
            fields.append(category)
        }
    }
    
}

class GenericFieldItem: FieldsViewModelItem {
    
     var genericData: [GenericField]
    
    var type: FieldItemType {
        return .genericField
    }
    
    var rowCount: Int {
        return genericData.count
    }
    
    init(genericData: [GenericField]) {
        self.genericData = genericData
    }
}

class CategoryFieldItem: FieldsViewModelItem {
    
    var categoryFieldData: [CategoryField]
    
    var type: FieldItemType {
        return .categoryField
    }
    
    var rowCount: Int {
        return categoryFieldData.count
    }
    
    init(categoryFieldData: [CategoryField]) {
        self.categoryFieldData = categoryFieldData
    }
}
