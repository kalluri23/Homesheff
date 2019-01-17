//
//  LocationTextCell.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/16/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class LocationTextCell: UITableViewCell {

    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var fieldValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
