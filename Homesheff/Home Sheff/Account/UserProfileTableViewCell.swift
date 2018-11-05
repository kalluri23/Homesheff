//
//  UserProfileTableViewCell.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    var isEditMode = false
    
    // dummy data
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateVisualElements() {
        
        guard placeHolderLabel.text != "EMAIL", placeHolderLabel.text != "LOCATION" else {
            valueTextField.isUserInteractionEnabled = false
            return
        }
        if isEditMode {
            valueTextField.borderStyle = .roundedRect
            valueTextField.isUserInteractionEnabled = true
        } else {
            valueTextField.borderStyle = .none
            valueTextField.isUserInteractionEnabled = false
        }
    }
    
}


