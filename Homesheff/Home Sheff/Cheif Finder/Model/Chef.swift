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

//{
//    "id": 41,
//    "firstName": "Sally",
//    "lastName": "Davidson",
//    "password": "yk3XlptPsTGrk+YhEdwO4MqzRzYcMFvIdvSLqmPDZ+I=",
//    "salt": null,
//    "email": "sally.test2@gmail.com",
//    "phone": "1234567890",
//    "zipcode": "21909",
//    "signUpDate": "2018-08-18T21:19:55.000+0000",
//    "isChef": true,
//    "isCustomer": false,
//    "isActive": true,
//    "imageURL": "https://i.imgur.com/wIir2lm.png",
//    "services": null
//}

struct Chef: Codable {
    var id: Int
    var firstName: String?
    var lastName: String?
    var password: String?
    var email: String?
    var phone: String?
    var zipcode: String?
    var signUpDate: String?
    var isChef: Bool?
    var isCustomer: Bool?
    var isActive: Bool?
    var imageURL: String?
    var coverURL: String?

    init(user: UserModel) {
        self.id = user.id!
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.password = user.password
        self.email = user.email
        self.phone = user.phone
        self.zipcode = user.zipcode
        self.signUpDate = user.signUpDate
        self.isChef = user.isChef
        self.isCustomer = user.isCustomer
        self.isActive = user.isActive
        self.imageURL = user.imageURL
    }
}
