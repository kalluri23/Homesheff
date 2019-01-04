//
//  SecureTextField.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 12/31/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class SecureTextField: UITextField {
    var showsAccessoryImage : Bool?{
        didSet{
            let visibilityButton = UIButton(type: .custom)
            visibilityButton.setImage(UIImage(named: "show-password")!, for: .normal)
            visibilityButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            visibilityButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            self.rightView = visibilityButton
            self.rightViewMode = .whileEditing
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if self.isSecureTextEntry {
            self.isSecureTextEntry = false
            sender.setImage(UIImage(named: "hide-password")!, for: .normal)
        }else {
            self.isSecureTextEntry = true
            sender.setImage(UIImage(named: "show-password")!, for: .normal)
        }
    }
    
}
