//
//  AboutTableViewCell.swift
//  Homesheff
//
//  Created by bkongara on 11/30/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

protocol AboutCellDelegate: AnyObject {
     func viewMoreClicked()
}

class AboutTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    
    weak var delegate: AboutCellDelegate?
    var aboutChef: String? {
        didSet {
            aboutLbl.text = aboutChef
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
    
    
    @IBAction func viewMoreClicked(_ sender: Any) {
        
        self.delegate?.viewMoreClicked()
    }
    
}
