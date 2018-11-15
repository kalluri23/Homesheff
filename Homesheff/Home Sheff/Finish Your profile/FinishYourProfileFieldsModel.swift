//
//  FinishYourProfileFieldsModel.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/3/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation


struct SelectServiceField {
    var name: String
    var isSelected = false

}

struct AddServiceFields {
    var genericField: GenericField
    var defaultService: [SelectServiceField]
    var selectedService: [SelectServiceField]? = nil
    
}


class FinishYourProfileFields {
    
    var genericFields = [GenericField]()
    var service: AddServiceFields?
    let chefUser = User.defaultUser.currentUser
    
    init() {
        self.addGenericData()
        self.addCollectionViewData()
    }
    
    private func addGenericData() {
        genericFields = [GenericField(name: chefUser?.firstName ?? "", placeHolder: "FIRST NAME"),GenericField(name: chefUser?.lastName ?? "", placeHolder: "LAST NAME"),GenericField(name: "", placeHolder: "BIO"),GenericField(name: chefUser?.email ?? "", placeHolder: "EMAIL"), GenericField(name: "" , placeHolder: "LOCATION"), GenericField(name: chefUser?.phone ?? "", placeHolder: "PHONE")]
    }
        
    private func addCollectionViewData(){
        
        let genericField = GenericField(name: "", placeHolder: "ADD SERVICES")
        let defaultService = [SelectServiceField(name: "Teaching", isSelected: false),SelectServiceField(name: "Meal Prep", isSelected: false),SelectServiceField(name: "Catering", isSelected: false),SelectServiceField(name: "Grocery Shopping", isSelected: false)]
        service = AddServiceFields(genericField: genericField, defaultService: defaultService, selectedService: nil)
        
    }
    
}

enum FinishYourProfileFieldItemType {
    case genericField
    case selectedServicesCollectionViewField
    case suggestedServicesCollectionViewField
}

