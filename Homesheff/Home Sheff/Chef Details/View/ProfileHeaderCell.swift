//
//  ProfileHeaderCellTableViewCell.swift
//  Homesheff
//
//  Created by bkongara on 1/6/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func editProfileHeader()
}

class ProfileHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImgView: CustomImageView!
    @IBOutlet weak var profileBgView: CustomImageView!
    @IBOutlet weak var profileHeading: UILabel!
    @IBOutlet weak var profileContact: UILabel!
    
    @IBOutlet weak var profileEditBtn: UIButton!
    weak var delegate: ProfileHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.width / 2
        self.profileImgView.clipsToBounds = true;
        self.profileImgView.layer.borderWidth = 3.0
        self.profileImgView.layer.borderColor = UIColor.white.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func editProfile(_ sender: Any) {
        self.delegate?.editProfileHeader()
    }
    
}
