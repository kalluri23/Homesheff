//
//  ForgotPasswordViewController.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 12/24/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet var forgotPasswordViewModel: ForgotPasswordViewModel!
    
    //TODO: Need to change these images when we get from Sakura
    let lockImage = UIImage(named: "lock")
    let sentImage = UIImage(named: "done")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureInitialScreen()
    }

    deinit {
        print("forgotpassword deinit called")
    }
    
    private func configureInitialScreen() {
        self.imageView.image = lockImage
        self.primaryLabel.text = "Forgot your password?"
        self.secondaryLabel.text = "Enter your email below and we will send a link to reset your password."
        self.sendButton(isEnabled:false)
    }
    
    private func confiugreSentScreen() {
        self.imageView.image = sentImage
        self.primaryLabel.text = "Email sent"
        self.secondaryLabel.text = "If the email you entered matches our records, you will short receive a link to reset to your password."
        self.sendButton(isEnabled: false)
        self.textField.resignFirstResponder()
    }
    
    private func sendButton(isEnabled : Bool) {
        self.sendButton.isEnabled = isEnabled
        self.sendButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    //TODO: Add the backend code to send email
    @IBAction func sendButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        forgotPasswordViewModel.forgotPassword(envelop: forgotPasswordViewModel.forgotPasswordEnvelop(email: self.textField.text!), completion: {[unowned self] isSuccess in
            if (isSuccess) {
                self.confiugreSentScreen()
            }else {
               print("error occured")
            }
            
        })
    }
    

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let emailText = textField.text, emailText.isValidEmail() {
            self.sendButton(isEnabled:true)
        }else {
            self.sendButton(isEnabled:false)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendButton(isEnabled: false)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let emailText = textField.text, emailText.isValidEmail() {
            self.sendButton(isEnabled:true)
            confiugreSentScreen()
            return true
        }else {
            self.sendButton(isEnabled:false)
            return false
        }
    }
}
