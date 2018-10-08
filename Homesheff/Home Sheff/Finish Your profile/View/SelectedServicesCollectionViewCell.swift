//
//  SelectedServicesCollectionViewCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/7/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class SelectedServicesCollectionViewCell: UICollectionViewCell {

    
    //needs to be connect to UI
    @IBOutlet weak var selectedServicesCollectionView: UICollectionView!

    var selectedServiceField: SelectedServicesCollectionViewField?
    {
        didSet {
            
            //genericNameLabel.text = geneircFields?.placeHolder
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
