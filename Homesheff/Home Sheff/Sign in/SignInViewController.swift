//
//  ViewController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UITextField{
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func bottomBorderWhite(){
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotYourPasswordButton: UIButton!
    @IBOutlet weak var createYourAccountButton: UIButton!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    
    let viewModel = SignInViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.color = .black
        loadingIndicator.type = .ballClipRotate
        
        usernameTextField.setPadding()
        usernameTextField.bottomBorderWhite()
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"User Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordTextField.setPadding()
        passwordTextField.bottomBorderWhite()
        
       
    }
    
    //hides navigation bar on SignIn screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //reappears navigation bar on next page
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapSignIn(_ sender: UIButton) {
        loadingIndicator.startAnimating()
        callLoginAPI()
//n call api from here
//      let baseTabbar = storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
//        self.present(baseTabbar, animated: false, completion: nil)
    }
    
    func callLoginAPI() {
        
        if usernameTextField.text !=  nil && passwordTextField.text != nil {
            viewModel.signInApi(envelop:userListEnvelop(userName: usernameTextField.text!, password: passwordTextField.text!)) { [weak self] isSuccess in
                
                if isSuccess{
                    self?.loadingIndicator.stopAnimating()
                    let baseTabbar = self?.storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
                    self?.present(baseTabbar, animated: false, completion: nil)
                } else {
                    // Throw an error here
                }
                
            }
        }
    }
    
    func userListEnvelop(userName: String, password: String) -> Requestable {
        
        let userListSearchPath = ServicePath.signInCall(userName: userName, password: password)
        let userListEnvelop = SignInEnvelop(pathType: userListSearchPath)
        
        return userListEnvelop
    }
}

extension SignInViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField .isEqual(usernameTextField) {
//
//        }
//    }
}
