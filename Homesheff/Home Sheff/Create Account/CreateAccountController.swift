//
//  CreateYourAccountController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/12/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


extension UITextField{
    
    func setBottomBorderLightGray(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class CreateAccountController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountTableView: UITableView!
    
    var username: String?
    var password: String?
    var phoneNo: String?
    
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!

    
    let viewModel = CreateAccountViewModel()
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func checkBoxTapped(_ sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadingIndicator.color = .black
        loadingIndicator.type = .ballClipRotate
        
//        firstNameTextField.setPadding()
//        firstNameTextField.setBottomBorderLightGray()
//        
//        lastNameTextField.setPadding()
//        lastNameTextField.setBottomBorderLightGray()
//        
//        emailTextField.setPadding()
//        emailTextField.setBottomBorderLightGray()
//        
//        passwordTextField.setPadding()
//        passwordTextField.setBottomBorderLightGray()
        
        //simplified back button on next page
       // self.navigationItem.backBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        
        // Register cell
        
        createAccountTableView.register(GenericFieldsCellTableViewCell.nib, forCellReuseIdentifier: GenericFieldsCellTableViewCell.reuseIdentifier)
        createAccountTableView.register(ChefFieldsCell.nib, forCellReuseIdentifier: ChefFieldsCell.reuseIdentifier)
        createAccountTableView.register(SignUpContentTableViewCell.nib, forCellReuseIdentifier: SignUpContentTableViewCell.reuseIdentifier)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func callSignupAPI() {
       
        let item = viewModel.fields[0]
        
        if item.type == .genericField {
              if let item = item as? GenericFieldItem {
                for value in item.genericData {
                    switch value.placeHolder {
                    case "Email":
                        username = value.name
                    case "Password":
                        password = value.name
                    case "Phone No":
                        phoneNo = value.name
                    default:
                        print(value.name)
                    }
                }
            }
        }
        
        signupAPI()
    }
    
    private func signupAPI() {
        
        if isTextFieldHasText() {
            loadingIndicator.startAnimating()
            
            viewModel.signUp(envelop: signUpEnvelop()) { [weak self] isSuccess in
                
                                if isSuccess{
                                  self?.navigationController?.popViewController(animated: true)
                                } else {
                                    self?.loadingIndicator.stopAnimating()
                                    self?.showAlert(title: "Oops!", message: "Please check your details")
                                }
                
                            }
        } else {
            self.showAlert(title: "Oops!", message: "Please check your details")
        }
    }
    
    private func isTextFieldHasText() -> Bool {
        if username?.isEmpty ?? false && password?.isEmpty ?? false && phoneNo?.isEmpty ?? false {
            return false
        }
        return true
    }
    
    private func navigateToFinishYourProfile() {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "finishProfileID")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
   private func signUpEnvelop() -> Requestable {
        
        let signupSearchPath = ServicePath.signUpCall(userName: username!, password: password!, phoneNo: phoneNo!)
        let signupEnvelop = SignUpEnvelop(pathType: signupSearchPath)
        
        return signupEnvelop
    }
}

extension CreateAccountController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fields[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.fields[indexPath.section]
        
        switch item.type {
        case .genericField:
            
            if let item = item as? GenericFieldItem {
                let cell: GenericFieldsCellTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.geneircFields = item.genericData[indexPath.row]
                cell.genericField.tag = indexPath.item
                cell.tag = indexPath.section
                cell.genericField.delegate = self
                return cell
            }
            
        case .categoryField:
            
            if let item = item as? CategoryFieldItem {
                let cell: ChefFieldsCell = tableView.dequeueReusableCell(for: indexPath)
                cell.category = item.categoryFieldData[indexPath.row]
                
                return cell
            }
            
        case .signupField:
            
            if let item = item as? SignupFieldItem {
                let cell: SignUpContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.signup = item.signupFieldsData
                
                cell.didTapSignUp = { [weak self] in
                    self?.callSignupAPI()
                }
                
                return cell
            }
   
           
        }
         return UITableViewCell()
    }
}

//TODO: Move it cell class
extension CreateAccountController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if viewModel.fields[0].type == .genericField {
            
            if let item = viewModel.fields[0] as? GenericFieldItem {
                item.genericData[textField.tag].name = textField.text ?? ""
                
                print(item.genericData[textField.tag].name)
            }
        }
    }
}

