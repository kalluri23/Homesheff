//
//  FinishYourProfileController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit


class FinishYourProfile : UIViewController{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    //following fields have their own search page
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addServicesTextField: UITextField!
    @IBOutlet weak var ratesTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        firstNameTextField.setPadding()
        firstNameTextField.setBottomBorderLightGray()
        
        lastNameTextField.setPadding()
        lastNameTextField.setBottomBorderLightGray()

        emailTextField.setPadding()
        emailTextField.setBottomBorderLightGray()

        locationTextField.setPadding()
        locationTextField.setBottomBorderLightGray()
        
        phoneTextField.setPadding()
        phoneTextField.setBottomBorderLightGray()
        
        addServicesTextField.setPadding()
        addServicesTextField.setBottomBorderLightGray()

        //delegate-CONTINUE STEP 16 FROM https://blog.apoorvmote.com/segue-when-tapped-on-textfield-pass-data-through-navigation-back-button-ios-swift/
        locationTextField.delegate = self as! UITextFieldDelegate
        addServicesTextField.delegate = self as! UITextFieldDelegate
        ratesTextField.delegate = self as! UITextFieldDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
