//
//  ProfileDetailedTableViewCell.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class CheffServicesCell: UITableViewCell {
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDescLabel: UILabel!
    
    var cheffService: SheffService? {
        didSet {
            self.serviceNameLabel.text = cheffService?.name
            self.serviceDescLabel.text = cheffService?.description
        }
    }
    
}
