//
//  ChefCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/16/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class ChefCell: UITableViewCell {

    @IBOutlet weak var cheffImageView: UIImageView!

    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var chefLocation: UILabel!
    
    @IBOutlet weak var chefRate: UILabel!
    
    func setChef(chef: Chef){
        cheffImageView.image = chef.chefImage
        chefName.text = chef.chefName
        chefLocation.text = chef.chefLocation
        chefRate.text = chef.chefRate
    }
    
}
