//
//  CreateYourAccountController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/12/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit


extension UITextField{
    
    func setBottomBorderLightGray(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class CreateAccountController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        firstNameTextField.setPadding()
        firstNameTextField.setBottomBorderLightGray()
        
        lastNameTextField.setPadding()
        lastNameTextField.setBottomBorderLightGray()
        
        emailTextField.setPadding()
        emailTextField.setBottomBorderLightGray()
        
        passwordTextField.setPadding()
        passwordTextField.setBottomBorderLightGray()
        
        //simplified back button on next page
        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

