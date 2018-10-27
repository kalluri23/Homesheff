//
//  FieldsModel.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation


struct GenericField {
    var name: String
    var placeHolder: String
}

struct CategoryField {
    var placeHolder: String
    var isSelected: Bool
}

struct SignUpField {
    var placeHolder: String
    var termsAndCondition: String
}


class Fields {
    
    var genericFields = [GenericField]()
    var categoryFields = [CategoryField]()
    var signUpFields: SignUpField!
    
    init() {
        self.addGenericData()
    }

    private func addGenericData() {
      genericFields = [GenericField(name: "", placeHolder: "First Name"),GenericField(name: "", placeHolder: "Last Name"),GenericField(name: "", placeHolder: "Email"),GenericField(name: "", placeHolder: "Password"), GenericField(name: "", placeHolder: "Phone No")]
        categoryFields = [CategoryField(placeHolder: "I want to be a Plantarian", isSelected: false),CategoryField(placeHolder: "I want to be a Chef", isSelected: false)]
        signUpFields = SignUpField(placeHolder: "Sign Up", termsAndCondition: "terms and condition")
        
    }
}

enum FieldItemType {
    case genericField
    case categoryField
}
