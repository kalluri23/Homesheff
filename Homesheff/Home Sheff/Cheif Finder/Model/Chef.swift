//
//  Chef.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/16/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

//{
//    "id": 41,
//    "firstName": "Sally",
//    "lastName": "Davidson",
//    "email": "sally.test2@gmail.com",
//    "phone": null,
//    "zipcode": null,
//    "signUpDate": "2018-08-18 17:19:55.0",
//    "isChef": true,
//    "isCustomer": null
//}

//class Chef {
//    var chefImage: UIImage
//    var chefName: String
//    var chefLocation: String
//    var chefRate: String
//
//    init(chefImage :UIImage, chefName: String, chefLocation: String, chefRate: String) {
//        self.chefImage = chefImage
//        self.chefName = chefName
//        self.chefLocation = chefLocation
//        self.chefRate = chefRate
//    }
//
//}


struct Chef: Codable {
    var id: Int
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var zipcode: String?
    var signUpDate: String?
    var isChef: Bool?
    var isCustomer: Bool?
}
