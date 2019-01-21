//
//  ChefCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/16/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class ChefCell: UITableViewCell {

    @IBOutlet weak var cheffImageView: CustomImageView!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var chefLocation: UILabel!
    
    var chef: Chef? {
        didSet{
            if let cheff  = chef {
                chefName.text = cheff.firstName
                chefLocation.text = cheff.location
                cheffImageView.downloadProfileImage(withId: "\(cheff.id)")
            }
        }
    }
}
