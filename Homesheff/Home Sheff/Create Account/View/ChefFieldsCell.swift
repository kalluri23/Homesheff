//
//  ChefFieldsCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class ChefFieldsCell: UITableViewCell {

    @IBOutlet weak var checkCategory: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var category: CategoryField? {
        didSet{
            categoryLabel.text = category?.placeHolder
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
    
    @IBAction func didSelectCheckCategory(_ sender: UIButton) {
    }
}
