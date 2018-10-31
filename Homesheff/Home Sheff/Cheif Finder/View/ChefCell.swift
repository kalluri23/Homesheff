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
    
    @IBOutlet weak var chefRate: UILabel!
    
    var chef: Chef? {
        didSet{
            cheffImageView.loadImageWithUrlString(urlString: chef?.imageURL ?? "")
            chefName.text = chef?.firstName
            chefLocation.text = "Virginia, USA"
            chefRate.text = "$25"
        }
    }
}
