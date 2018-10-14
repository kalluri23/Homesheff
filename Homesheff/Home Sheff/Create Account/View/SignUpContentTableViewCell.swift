//
//  SignUpContentTableViewCell.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class SignUpContentTableViewCell: UITableViewCell {
    
    var didTapSignUp: (() -> Void)?
    
    var signup: SignUpField? {
        didSet{
            print(signup?.placeHolder)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapSignup(_ sender: UIButton) {
           self.didTapSignUp?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
