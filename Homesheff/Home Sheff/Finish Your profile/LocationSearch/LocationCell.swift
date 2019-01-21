//
//  LocationCell.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/16/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    var location: Location? {
        didSet {
            if let location = self.location {
                self.cityLabel.text = location.city
                self.stateLabel.text = "\(location.state),"
                self.zipCodeLabel.text = location.zip
            }
        }
    }
    
}
