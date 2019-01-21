//
//  CheffLocationCell.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/18/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class CheffLocationCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: CustomImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var chefService : ChefService? {
        didSet {
            if let cheff  = chefService {
                firstName.text = "\(cheff.firstName), "
                distance.text = cheff.distance
                location.text = cheff.location
                profileImage.downloadProfileImage(withId: cheff.id)
            }
        }
    }

}
