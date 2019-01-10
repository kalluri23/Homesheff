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
    var userPreferenceId: Int?
    var imageUrl: String?
    var thumbnailUrl: String?
    var createdDate: String?
}
