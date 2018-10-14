//
//  CollectionReusableView.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/10/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var nib:UINib {
        return UINib(nibName: "CollectionReusableView", bundle: nil)
    }
    
}
