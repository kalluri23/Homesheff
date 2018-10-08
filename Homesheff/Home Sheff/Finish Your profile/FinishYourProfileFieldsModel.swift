//
//  FinishYourProfileFieldsModel.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/3/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation


struct SelectedServicesCollectionViewField {
    var addedSelectedServices: SelectedServicesCollectionViewCell
}

struct SuggestedServicesCollectionViewField {
    var suggestedServices: String
    var addSuggestedServices: SuggestedServicesCollectionViewCell

}


class FinishYourProfileFields {
    
    var genericFields = [GenericField]()
    var selectedCollectionViewFields = [SelectedServicesCollectionViewField]()
    var suggestedCollectionViewFields = [SuggestedServicesCollectionViewField]()
    
    init() {
        self.addGenericData()
    }
    
    private func addGenericData() {
        genericFields = [GenericField(name: "FIRST NAME", placeHolder: ""),GenericField(name: "LAST NAME", placeHolder: ""),GenericField(name: "EMAIL", placeHolder: ""),GenericField(name: "LOCATION", placeHolder: ""), GenericField(name: "PHONE", placeHolder: ""), GenericField(name: "ADD SERVICES", placeHolder: "Service (ex. teaching)"), GenericField(name: "RATES", placeHolder: "$ 0.00 /hour")]
    }
        
    private func addCollectionViewData(){
        //NOT SURE HOW TO SET DEFAULT CELL VALUES 
     //   selectedCollectionViewFields = [SelectedServicesCollectionViewField(addedSelectedServices: <#T##SelectedServicesCollectionViewCell#> )]
     //   suggestedCollectionViewFields = [SuggestedServicesCollectionViewField(suggestedServices: "Suggested chef services:", addSuggestedServices: <#T##SuggestedServicesCollectionViewCell#>)]
        
    }
    
}

enum FinishYourProfileFieldItemType {
    case genericField
    case selectedServicesCollectionViewField
    case suggestedServicesCollectionViewField
}

