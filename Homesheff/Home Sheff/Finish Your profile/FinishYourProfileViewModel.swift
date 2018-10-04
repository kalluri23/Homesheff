//
//  FinishYourProfileViewModel.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/3/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

//protocol FieldsViewModelItem {
//    var type: FieldItemType { get }
//    var rowCount: Int { get }
//}

class FinishYourProfileViewModel: NSObject {
    
    let fieldData = Fields()
    var fields = [FieldsViewModelItem]()
    
    override init() {
        
        if  !fieldData.genericFields.isEmpty {
            let genericFields = GenericFieldItem(genericData: fieldData.genericFields)
            fields.append(genericFields)
        }
//        if  !fieldData.categoryFields.isEmpty {
//            let category = CategoryFieldItem(categoryFieldData: fieldData.categoryFields)
//            fields.append(category)
//        }
//        if  !fieldData.signUpFields.placeHolder.isEmpty {
//            let signupFields = SignupFieldItem(signupFieldsData: fieldData.signUpFields)
//            fields.append(signupFields)
//        }
    }
    
}

//class GenericFieldItem: FieldsViewModelItem {
//
//    var genericData: [GenericField]
//
//    var type: FieldItemType {
//        return .genericField
//    }
//
//    var rowCount: Int {
//        return genericData.count
//    }
//
//    init(genericData: [GenericField]) {
//        self.genericData = genericData
//    }
//}
//
//class CategoryFieldItem: FieldsViewModelItem {
//
//    var categoryFieldData: [CategoryField]
//
//    var type: FieldItemType {
//        return .categoryField
//    }
//
//    var rowCount: Int {
//        return categoryFieldData.count
//    }
//
//    init(categoryFieldData: [CategoryField]) {
//        self.categoryFieldData = categoryFieldData
//    }
//}
//
//
//class SignupFieldItem: FieldsViewModelItem {
//
//    var signupFieldsData: SignUpField!
//
//    var type: FieldItemType {
//        return .signupField
//    }
//
//    var rowCount: Int {
//        return 1
//    }
//
//    init(signupFieldsData: SignUpField) {
//        self.signupFieldsData = signupFieldsData
//    }
//}
