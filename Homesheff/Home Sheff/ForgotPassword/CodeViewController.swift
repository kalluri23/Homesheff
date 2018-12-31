//
//  CodeViewController.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 12/30/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class CodeViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var continueButton: SpinningButton!
    @IBOutlet var codeViewModel: ForgotPasswordViewModel!
    @IBOutlet weak var textField: UITextField!
    
    var email:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(email != nil, "Email should be provided to reach this screen")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureInitialScreen()
    }
    
    @IBAction func continueButtonTapped(_ sender: SpinningButton) {
        callValidateCodeApi()
    }
    
    @IBAction func sendCodeButtonTapped(_ sender: UIButton) {
        callForgotPasswordAPI()
    }
    
    private func callValidateCodeApi() {
        self.continueButton.showLoading()
        self.textField.resignFirstResponder()
        codeViewModel.validateCode(envelop: codeViewModel.validateCodeEnvelop(email: email!, code: textField.text!), completion: {[unowned self] isSuccess in
            self.continueButton.isEnabled(false)
            self.continueButton.hideLoading()
            if (isSuccess) {
               self.performSegue(withIdentifier: "ResetPasswordSegue", sender: self)
            }else {
                //Show failure alert here
                print("error validating code")
            }
            
        })
    }
    
    private func callForgotPasswordAPI() {
        codeViewModel.forgotPassword(envelop: codeViewModel.forgotPasswordEnvelop(email: email!), completion: {[unowned self] isSuccess in
            if (isSuccess) {
                //Show success alert
            }else {
                //Show failure alert
            }
            
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resetPasswordVC = segue.destination as? ResetPasswordViewController {
            resetPasswordVC.email = email!
            resetPasswordVC.code = textField.text!
        }
    }
    
    private func configureInitialScreen() {
        self.infoLabel.text = "A code has been sent to your email address:\(email!). Please enter that code here to proceed to next steps"
        self.continueButton.isEnabled(false)
        self.textField.becomeFirstResponder()
    }

}

extension CodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        self.continueButton.isEnabled(count==6)
        return count <= 6
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.count == 6 {
            self.continueButton.isEnabled(true)
            callValidateCodeApi()
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
