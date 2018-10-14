//
//  SelectedServicesCollectionViewCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 10/7/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class SelectedServicesCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var contentBackgroundView: UIView!
    
    var contentBackgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = contentBackgroundColor
            contentBackgroundView.backgroundColor = contentBackgroundColor
            serviceLabel.textColor = .appDefaultColor
        }
    }
    
    
   
    @IBOutlet weak var serviceLabel: UILabel!
    //needs to be connect to UI
    @IBOutlet weak var selectedServicesCollectionView: UICollectionView!

    @IBOutlet weak var widthConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setCollectionViewCellEffect()
        
      //  self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    func setCollectionViewCellEffect()  {
        
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.appDefaultColor.cgColor
        self.contentView.layer.masksToBounds = true
        
    }

}
