//
//  CollectionViewCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/4/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genericNameLabel: UILabel!
    @IBOutlet weak var genericField: UITextField!
    
    var geneircFields: GenericField? {
        didSet {
            
            genericNameLabel.text = geneircFields?.placeHolder
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
        // Configure the view for the selected state
}


