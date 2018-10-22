//
//  GenericFieldsCellTableViewCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class GenericFieldsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var genericNameLabel: UILabel!
    @IBOutlet weak var genericField: UITextField!
    
    //var didTapSignUp: ((String) -> Void)?
    
    var geneircFields: GenericField? {
        didSet {
           
            genericNameLabel.text = geneircFields?.placeHolder
            
            if geneircFields?.placeHolder == "Password" {
                genericField.isSecureTextEntry =  true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
