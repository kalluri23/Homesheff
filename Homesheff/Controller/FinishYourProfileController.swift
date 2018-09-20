//
//  FinishYourProfileController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit


class FinishYourProfile : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    //following fields have their own search page
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addServicesTextField: UITextField!
    @IBOutlet weak var ratesTextField: UITextField!
    
    var location: String?
    var services: String?
    var rates: String?
    
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


        locationTextField.delegate = self
        //addServicesTextField.delegate = self
        //ratesTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationTextField.text = location
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        performSegue(withIdentifier: "locationPage", sender: self)
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "locationPage" {
            
            let locationController = segue.destination as! LocationServicesRatesViewController
            
            locationController.location = locationTextField.text
        }
    }
    
    
}
