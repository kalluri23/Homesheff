//
//  SuggestedServicesCollectionViewCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/7/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class SuggestedServicesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genericNameLabel: UILabel!
    
    //need to be connect to UI
    @IBOutlet weak var suggestedServicesCollectionView: UICollectionView!

    var geneircFields: GenericField?
    var suggestedServiceField: SuggestedServicesCollectionViewField?
    {
        didSet {
            
            genericNameLabel.text = geneircFields?.placeHolder
            //
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
