//
//  ViewController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FBSDKLoginKit

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
    @IBOutlet weak var facebookButton: FacebookButton!
    
    let viewModel = SignInViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
              //TODO: Manage session time out from API --later
        /*if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            let baseTabbar = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
            self.present(baseTabbar, animated: false, completion: nil)
        }*/
        
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
        callLoginAPI()
    }
    
    @IBAction func facebookButtonTapped(_ sender: FacebookButton) {
        self.startFacebookFlow(sender: sender)
    }
    
    @IBAction func createAccountTapped() {
        self.performSegue(withIdentifier: "CreateAccountSegue", sender: self)
    }
    
    
    //MARK: - Helper functions
    private func isTextFieldHasText() -> Bool {
        if usernameTextField.text?.isEmpty ?? false || passwordTextField.text?.isEmpty ?? false {
            return false
        }
        return true
    }
    
    private func callLoginAPI() {
        
        if isTextFieldHasText() {
            loadingIndicator.startAnimating()
            viewModel.signInApi(envelop: viewModel.signInEnvelop(userName: usernameTextField.text!, password: passwordTextField.text!)) { [weak self] isSuccess in
                
                if isSuccess{
                    
                    //TODO: Manage session time out from API --later
                    
                    let baseTabbar = self?.storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
                    self?.present(baseTabbar, animated: false, completion: nil)
                } else {
                    self?.showAlert(title: "Oops!", message: "Please check your email address & password")
                }
                self?.loadingIndicator.stopAnimating()
            }
        } else {
            self.showAlert(title: "Oops!", message: "Please check your email address & password")
        }
    }
    
    private func startFacebookFlow(sender: FacebookButton) {
        let loginManager = FBSDKLoginManager()
        guard let currentUser = FBSDKAccessToken.current() else {
            sender.showActivity()
            loginManager.loginBehavior = .systemAccount
            loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: { [unowned self] (result, error) in
                sender.hideActivity()
                if let loginError = error {
                    print(loginError.localizedDescription)
                    loginManager.logOut()
                    sender.setTitle(withText:"Sign in with Facebook")
                    self.showAlertWith(alertTitle: "Facebook Login Error", alertBody: "Unable to access your facebook account. Please try again.", action: {
                        loginManager.logOut()
                    })
                }else {
                    if let loginResult = result {
                        if !loginResult.isCancelled {
                            self.createAccountTapped()
                        }else {
                            print(loginResult.token)
                            print(loginResult.grantedPermissions)
                            print(loginResult.declinedPermissions)
                        }
                    }
                }
            })
            return
        }
        self.createAccountTapped()
    }
}

