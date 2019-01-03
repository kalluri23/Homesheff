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
    private let placeholderImageUrl = "https://png.icons8.com/color/2x/person-female.png"
    
    var chef: Chef? {
        didSet{
            // cheffImageView.loadImageWithUrlString(urlString: chef?.imageURL ?? placeholderImageUrl)
            chefName.text = chef?.firstName
            chefLocation.text = "Virginia, USA"
            chefRate.text = ""
        }
    }
}
