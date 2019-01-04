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
    @IBOutlet weak var sendButton: SpinningButton!
    @IBOutlet var forgotPasswordViewModel: ForgotPasswordViewModel!
    
    //TODO: Need to change these images when we get from Sakura
    let lockImage = UIImage(named: "lock")
    let sentImage = UIImage(named: "done")
    let errorImage = UIImage(named: "error")
    
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
        self.sendButton.isEnabled(false)
        self.textField.becomeFirstResponder()
    }
    
    private func confiugreSentScreen() {
        self.imageView.image = sentImage
        self.primaryLabel.text = "Email sent"
        self.secondaryLabel.text = "If the email you entered matches our records, you will short receive a code to verify your account and proceed to next steps"
        self.performSegue(withIdentifier: "ConfirmAccountSegue", sender: self)
    }
    
    private func confiugreErrorScreen() {
        self.imageView.image = errorImage
        self.primaryLabel.text = "Error sending email"
        self.secondaryLabel.text = "We are unable to send email at this time. It is possible that email you enterd is not registered with us"
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let codeVC = segue.destination as? CodeViewController {
            codeVC.email = self.textField.text!
        }
    }
    
    /**
    Method to call forgotPassword Endpoint using email
    */
    private func callForgotPasswordAPI() {
        self.sendButton.showLoading()
        self.textField.resignFirstResponder()
        forgotPasswordViewModel.forgotPassword(envelop: forgotPasswordViewModel.forgotPasswordEnvelop(email: self.textField.text!), completion: {[unowned self] isSuccess in
            self.sendButton.isEnabled(false)
            self.sendButton.hideLoading()
            if (isSuccess) {
                self.confiugreSentScreen()
            }else {
                self.confiugreErrorScreen()
            }
            
        })
    }
    
    @IBAction func sendButtonTapped() {
        callForgotPasswordAPI()
    }
    

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let emailText = textField.text, emailText.isValidEmail() {
            self.sendButton.isEnabled(true)
        }else {
            self.sendButton.isEnabled(false)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendButton.isEnabled(false)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let emailText = textField.text, emailText.isValidEmail() {
            self.sendButton.isEnabled(true)
            callForgotPasswordAPI()
            return true
        }else {
            self.sendButton.isEnabled(false)
            return false
        }
    }
}
