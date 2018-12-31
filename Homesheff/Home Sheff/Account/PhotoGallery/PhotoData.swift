//
//  PhotoData.swift
//  Homesheff
//
//  Created by bkongara on 12/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

struct PhotoData: Codable {
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
    var photos: [String]?
    var coverURL: String?

}
