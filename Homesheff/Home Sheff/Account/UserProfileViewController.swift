//
//  UserProfileViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import Alamofire

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userProfileTableView: UITableView!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userCoverPicture: UIImageView!
    // we have to change these value to MVVM later
    //TODO :----
    let viewModel = UserProfileViewModel()
    var chefUser = User.defaultUser.currentUser
    var data = [GenericField]()
    var isEditMode = false
    private var isProfilePhotoSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserProfileImage()
        data =  [GenericField(name: self.chefUser?.firstName ?? "", placeHolder: "FIRST NAME"),GenericField(name: self.chefUser?.lastName ?? "", placeHolder: "LAST NAME"),GenericField(name: self.chefUser?.email ?? "", placeHolder: "EMAIL"),GenericField(name: self.chefUser?.location ?? "Georgetown, Washington, D.C.", placeHolder: "LOCATION"),GenericField(name: self.chefUser?.phone ?? "", placeHolder: "PHONE")]
        userProfileTableView.register(UserProfileTableViewCell.nib, forCellReuseIdentifier: UserProfileTableViewCell.reuseIdentifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editSaveProfile))
        
        userProfilePicture.layer.borderWidth = 1
        userProfilePicture.layer.masksToBounds = false
        userProfilePicture.layer.borderColor = UIColor.lightGray.cgColor
        userProfilePicture.layer.cornerRadius = userProfilePicture.frame.height/2
        userProfilePicture.clipsToBounds = true
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
    
    func updateUserProfileImage() {
        
        viewModel.downloadImage(imageName: "\(chefUser?.id ?? 0)_ProfilePhoto") { (profilePhoto) in
            self.userProfilePicture.image = profilePhoto
        }
        
        viewModel.downloadImage(imageName: "\(chefUser?.id ?? 0)_CoverPhoto") { (coverPhoto) in
            self.userCoverPicture.image = coverPhoto
        }
    }
    
    private func updateUserProfileEnvelop() -> Requestable {
        
        let updateUserProfileSearchPath = ServicePath.updateUserPreferenceCall(firstName: data[0].name, lastName: data[1].name, headline: "", phoneNo: data[4].name, location: data[3].name, zipCode: "", services: "", isChef: chefUser?.isChef, isCustomer: chefUser?.isCustomer)
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
            case 3:
                chefUser?.location = textField.text
            case 4:
                chefUser?.phone = textField.text
            default:
                break
            }
        }
        User.defaultUser.currentUser = chefUser
    }
}

extension UserProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func importProfileImage(_ sender: UIButton)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //CAN ALSO ADD SOURCE TYPE: CAMERA
        //determined whether the user can edit their image before uploading
        isProfilePhotoSelected = (sender.tag == 1)
        image.allowsEditing = false
        
        self.present(image, animated: true){
            //after it is complete
        }
    }
    
    
    //when the user has picked the image, checking if item can be converted to an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if isProfilePhotoSelected {
                userProfilePicture.image = image
                viewModel.uploadPhoto(photo: image, photoName: "ProfilePhoto")
                
            } else {
                userCoverPicture.image = image
                viewModel.uploadPhoto(photo: image, photoName: "CoverPhoto")
            }
            
        }
        else{
            print("picture failed to upload")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
