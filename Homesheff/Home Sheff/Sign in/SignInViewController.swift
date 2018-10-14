//
//  ViewController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

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
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        //simplified back button on next page
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
//
//
//        //makes navigation bar transparent for Sign In page
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
        
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
//n call api from here
//      let baseTabbar = storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
//        self.present(baseTabbar, animated: false, completion: nil)
    }
    
    func callLoginAPI() {
        
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
