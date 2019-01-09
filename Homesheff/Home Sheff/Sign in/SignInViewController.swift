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
    @IBOutlet weak var signInViewModel: SignInViewModel!
    
    var fbDetails: Details!
    //MARK: - Life Cycle Methods
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
    
    /** hides navigation bar on SignIn screen
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /** reappears navigation bar on next page
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createAccountVC = segue.destination as! CreateAccountController
        if let source = sender, source is FacebookButton {
            createAccountVC.isFaceBookSignUp = true
            createAccountVC.basicDetails = self.fbDetails
        }else {
            createAccountVC.basicDetails = Details()
        }
    }
    
    //MARK: - IBActions

    @IBAction func didTapSignIn(_ sender: UIButton) {
        callLoginAPI()
    }
    
    @IBAction func facebookButtonTapped(_ sender: FacebookButton) {
        self.startFacebookFlow(sender: sender)
    }
    
    @IBAction func createAccountTapped(sender: Any) {
       self.performSegue(withIdentifier: "CreateAccountSegue", sender: sender)
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
            signInViewModel.signInApi(envelop: signInViewModel.signInEnvelop(userName: usernameTextField.text!, password: passwordTextField.text!)) { [weak self] isSuccess in
                
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
            loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { [unowned self] (result, error) in
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
                            self.getFBDetails {[unowned self] (fbDetails) in
                               self.fbDetails = fbDetails
                               self.createAccountTapped(sender: sender)
                            }
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
        self.getFBDetails {[unowned self] (fbDetails) in
            if let declinedPermissions = currentUser.declinedPermissions, !declinedPermissions.isEmpty {
                print(declinedPermissions)
            }else {
                self.fbDetails = fbDetails
                self.createAccountTapped(sender: sender)
            }
        }
    }
    
    /** Get Email, First Name and Last Name of the user to pre-populate on sign up screen
    */
    private func getFBDetails(completion: @escaping (Details) -> Void) {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email, picture.type(small)"]).start { [unowned self]  _, result, error in
            if let detailsError = error {
               print(detailsError.localizedDescription)
                self.showAlertWith(alertTitle: "Facebook Login Error", alertBody: "Unable to access your facebook account. Please try again.")
            }else {
                if let fbDetails = result as? [String : Any],
                   let email = fbDetails["email"] as? String,
                   let first_name = fbDetails["first_name"],
                   let last_name = fbDetails["last_name"] {
                    print("\(email) \(first_name) \(last_name)")
                    if let imageJSON = fbDetails["picture"] as? Dictionary<String,Any>,
                       let imageURLJSON = imageJSON["data"] as? Dictionary<String,Any>,
                       let imageURL = imageURLJSON["url"] as? String{
                        print(imageURL)
                    }
                    
                    completion(Details(fbDetails))
                }else {
                    print("fbdetails are emty")
                }
            }
        }
    }
}

