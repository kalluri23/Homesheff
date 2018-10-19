//
//  User.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/18/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int
    var username: String
    var password: String
    var phone: String
    var isActive: Bool
}
