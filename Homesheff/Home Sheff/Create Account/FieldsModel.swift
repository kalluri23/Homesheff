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


class Fields {
    
    var genericFields = [GenericField]()
    var categoryFields = [CategoryField]()
    
    init() {
        addGenericData()
    }

    private func addGenericData() {
      genericFields = [GenericField(name: "", placeHolder: "First Name"),GenericField(name: "", placeHolder: "Last Name"),GenericField(name: "", placeHolder: "Email"),GenericField(name: "", placeHolder: "Password")]
        categoryFields = [CategoryField(placeHolder: "I want to be a chef", isSelected: false),CategoryField(placeHolder: "I want to be a customer", isSelected: false)]
    }
}
