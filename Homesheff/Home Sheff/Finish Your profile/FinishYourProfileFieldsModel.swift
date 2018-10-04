//
//  FinishYourProfileFieldsModel.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/3/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation


struct CollectionViewField {
    var addServices: String
    var placeholder: String
}

class FinishYourProfileFields {
    
    var genericFields = [GenericField]()
    //var collectionViewFields = [CollectionViewField]()
    
    init() {
        self.addGenericData()
    }
    
    private func addGenericData() {
        genericFields = [GenericField(name: "FIRST NAME", placeHolder: ""),GenericField(name: "LAST NAME", placeHolder: ""),GenericField(name: "EMAIL", placeHolder: ""),GenericField(name: "LOCATION", placeHolder: ""), GenericField(name: "PHONE", placeHolder: ""), GenericField(name: "RATES", placeHolder: "$ 0.00 /hour")]
        
      // collectionViewFields = [CollectionViewField(addServices: "LOCATION", placeholder: "Service (ex. teaching)")]
       
        
    }
}

