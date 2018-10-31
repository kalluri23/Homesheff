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
    
  //  @IBOutlet weak var termsOfServiceTextView: UITextView!
    
    
    var signup: SignUpField? {
        didSet{
            print(signup?.placeHolder)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
      //  let attributedString = NSMutableAttributedString(attributedString: termsOfServiceTextView.attributedText)
        
//        if attributedString.setAsLink(textToFind: "Terms of Service", linkURL: "https://homesheff.com/#/terms-of-service") && attributedString.setAsLink(textToFind: "Privacy Statement", linkURL: "https://homesheff.com/#/privacy-policy") {
//            termsOfServiceTextView.attributedText = attributedString
//        }
    }

    @IBAction func didTapSignup(_ sender: UIButton) {
           self.didTapSignUp?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


