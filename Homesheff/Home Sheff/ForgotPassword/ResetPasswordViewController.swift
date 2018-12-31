//
//  ResetPasswordViewController.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 12/30/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var passwordRulesLabel: UILabel!
    @IBOutlet var resetPasswordViewModel: ForgotPasswordViewModel!
    @IBOutlet weak var continueButton: SpinningButton!
    @IBOutlet weak var textField: SecureTextField!
    
    var email: String!
    var code: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.showsAccessoryImage = true
        assert((email != nil && code != nil), "Code and Email should be passed to this view controller to reach this screen")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureInitialScreen()
    }
    
    @IBAction func continueButtonTapped(_ sender: SpinningButton) {
        callResetPasswordAPI()
    }
    
    private func configureInitialScreen() {
        self.continueButton.isEnabled(false)
        self.infoLabel.text = "Create a new passwsord. You'll use this password to access your HomeSheff account"
        self.passwordRulesLabel.text = "Password must have atleast one uppercase character, one lowercase  character, one digit and 8 characters long"
        
        self.textField.becomeFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func callResetPasswordAPI() {
        self.continueButton.showLoading()
        self.textField.resignFirstResponder()
        resetPasswordViewModel.resetPassword(envelop: resetPasswordViewModel.resetPasswordEnvelop(email: email!, code: code!, password: textField.text!), completion: {[unowned self] isSuccess in
            DispatchQueue.main.async {
                self.continueButton.hideLoading()
                self.continueButton.isEnabled(false)
                if (isSuccess) {
                    self.showAlertWith(alertTitle: "Your password has been reset successfully. Please continue login.", action: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    self.navigationController?.popToRootViewController(animated: true)
                }else {
                    self.showAlertWith(alertTitle: "Error", alertBody: "Unable to reset your password at this time. Pldease try again later", action: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
            }
        })
    }

}

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, text.isValidPassword() {
            self.continueButton.isEnabled(true)
        }else {
            self.continueButton.isEnabled(false)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isValidPassword() {
            self.continueButton.isEnabled(true)
            callResetPasswordAPI()
            return true
        }else {
            self.continueButton.isEnabled(false)
            return false
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.continueButton.isEnabled(false)
        return true
    }
}
