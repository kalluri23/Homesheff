//
//  Chef.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/16/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

class Chef {
    var chefImage: UIImage
    var chefName: String
    var chefLocation: String
    var chefRate: String

    init(chefImage :UIImage, chefName: String, chefLocation: String, chefRate: String) {
        self.chefImage = chefImage
        self.chefName = chefName
        self.chefLocation = chefLocation
        self.chefRate = chefRate
    }
    
}
