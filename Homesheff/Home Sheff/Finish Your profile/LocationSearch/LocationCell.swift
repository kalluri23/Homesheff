//
//  LocationCell.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/16/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    var location: MKPlacemark? {
        didSet {
            if let location = self.location {
                self.cityLabel.text = location.locality
                self.stateLabel.text = "\(location.administrativeArea ?? ""),"
                self.zipCodeLabel.text = location.postalCode
            }
        }
    }
    
}
