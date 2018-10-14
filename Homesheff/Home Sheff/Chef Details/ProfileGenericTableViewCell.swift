//
//  ProfileGenericTableViewCell.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class ProfileGenericTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceIconImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceLocationLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var partCount1: UILabel!
    @IBOutlet weak var partyCount3: UILabel!
    
    @IBOutlet weak var partyCount2: UILabel!
    var chefDetails: ChefServices? {
        didSet {
            
            serviceIconImageView.image = UIImage(named: chefDetails?.imageName ?? "")
            serviceNameLabel.text = chefDetails?.name ?? ""
            serviceLocationLabel.text = chefDetails?.serviceLocation ?? ""
            servicePriceLabel.text = chefDetails?.servicePrice ?? "$0.00"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
