//
//  UserProfileViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userProfileTableView: UITableView!
    @IBOutlet weak var userProfilePicture: UIImageView!
    // we have to change these value to MVVM later
    //TODO :----
    let viewModel = UserProfileViewModel()
    var chefUser = User.defaultUser.currentUser
    var data = [GenericField]()
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       data =  [GenericField(name: self.chefUser?.firstName ?? "", placeHolder: "FIRST NAME"),GenericField(name: self.chefUser?.lastName ?? "", placeHolder: "LAST NAME"),GenericField(name: self.chefUser?.email ?? "", placeHolder: "EMAIL"),GenericField(name: "Georgetown, Washington, D.C.", placeHolder: "LOCATION"),GenericField(name: self.chefUser?.phone ?? "", placeHolder: "PHONE")]
        userProfileTableView.register(UserProfileTableViewCell.nib, forCellReuseIdentifier: UserProfileTableViewCell.reuseIdentifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editSaveProfile))
    }
    
    @objc func editSaveProfile() {
        
        view.endEditing(true)
        if isEditMode {
            saveUserProfile()
        }
        self.navigationItem.rightBarButtonItem?.title = isEditMode ? "Edit" : "Save"
        isEditMode = !isEditMode
        userProfileTableView.reloadData()
    }
    
    func saveUserProfile() {
        viewModel.updateUserProfile(envelop: updateUserProfileEnvelop()) { (success) in
            
        }
    }
    
    private func updateUserProfileEnvelop() -> Requestable {
        
        let updateUserProfileSearchPath = ServicePath.updateUserPreferenceCall(firstName: data[0].name, lastName: data[1].name, headline: "", phoneNo: data[4].name, location: data[3].name, zipCode: "", services: [], isChef: chefUser?.isChef, isCustomer: chefUser?.isCustomer)
        let path = "updateUserPreferences/" + "\(chefUser?.id ?? 0)"
        let updateUserProfile = UpdateUserPreferencesEnvelop(apiPath: path, pathType: updateUserProfileSearchPath)
        return updateUserProfile
    }
    
}

extension UserProfileViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserProfileTableViewCell = userProfileTableView.dequeueReusableCell(for: indexPath)
        cell.placeHolderLabel.text = data[indexPath.row].placeHolder
        cell.valueTextField.text = data[indexPath.row].name
        cell.isEditMode = isEditMode
        cell.updateVisualElements()
        cell.valueTextField.delegate = self
        cell.valueTextField.tag = indexPath.item
        return cell
    }
}

//TODO: Move it cell class
extension UserProfileViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldText = textField.text {
            var currentData = data[textField.tag]
            currentData.name = textFieldText
            data[textField.tag] = currentData
            
            switch textField.tag {
            case 0:
                chefUser?.firstName = textField.text
            case 1:
                chefUser?.lastName = textField.text
            case 4:
                chefUser?.phone = textField.text
            default:
                break
            }
        }
        User.defaultUser.currentUser = chefUser
    }
}
