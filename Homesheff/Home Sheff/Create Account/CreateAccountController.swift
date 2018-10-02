//
//  CreateYourAccountController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/12/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit


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
        
        firstNameTextField.setPadding()
        firstNameTextField.setBottomBorderLightGray()
        
        lastNameTextField.setPadding()
        lastNameTextField.setBottomBorderLightGray()
        
        emailTextField.setPadding()
        emailTextField.setBottomBorderLightGray()
        
        passwordTextField.setPadding()
        passwordTextField.setBottomBorderLightGray()
        
        //simplified back button on next page
        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        
        // Register cell
        
        createAccountTableView.register(GenericFieldsCellTableViewCell.nib, forCellReuseIdentifier: GenericFieldsCellTableViewCell.reuseIdentifier)
        createAccountTableView.register(ChefFieldsCell.nib, forCellReuseIdentifier: ChefFieldsCell.reuseIdentifier)
        createAccountTableView.register(SignUpContentTableViewCell.nib, forCellReuseIdentifier: SignUpContentTableViewCell.reuseIdentifier)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                return cell
            }
   
           
        }
         return UITableViewCell()
    }
    
}

