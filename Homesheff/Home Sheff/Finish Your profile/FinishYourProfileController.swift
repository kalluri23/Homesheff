//
//  FinishYourProfileControllerr.swift
//  Homesheff
//
//  Created by Anurag Pandey on 12/29/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

class FinishYourProfileController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var finishYourProfileTableView: UITableView!
    private let viewModel = FinishYourProfileViewModel()
    private let userProfileViewwModel = UserProfileViewModel()
    private var isProfilePhotoSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    override func viewDidLayoutSubviews(){
        finishYourProfileTableView.frame = CGRect(x: finishYourProfileTableView.frame.origin.x, y: finishYourProfileTableView.frame.origin.y, width: finishYourProfileTableView.frame.size.width, height: finishYourProfileTableView.contentSize.height)
        finishYourProfileTableView.reloadData()
    }
    
    func configureUIElements() {
        
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().greenThemeColor
        let saveBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveUserProfile))
        saveBarButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = saveBarButton
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    @objc func saveUserProfile() {
        
        view.endEditing(true)
        guard let finishUserProfileEnvelop = finishUserProfileEnvelop()  else {
            return
        }
        viewModel.finishUserProfile(envelop: finishUserProfileEnvelop) { (success) in
            if success {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarControllerId") as! BaseTabbarController
                self.present(vc, animated: true, completion: nil)
            } else {
                self.showAlert(title: "Oops!", message: "Please check your details")
            }
        }
    }
    
    private func finishUserProfileEnvelop() -> Requestable? {
        
        let user = User.defaultUser.currentUser
        if viewModel.validateUserInput() {
            let finishYourProfileSearchPath = ServicePath.finishYourProfileCall(firstName: viewModel.userEnteredData[viewModel.profileFields[0]] , lastName: viewModel.userEnteredData[viewModel.profileFields[1]], headline: viewModel.userEnteredData[viewModel.profileFields[2]], phoneNo: viewModel.userEnteredData[viewModel.profileFields[3]], location: viewModel.userEnteredData[viewModel.profileFields[4]], isChef: user?.isChef, isCustomer: user?.isCustomer)
            let path = "updateUserPreferences/" + "\(user?.id ?? 0)"
            let updateUserProfile = UpdateUserPreferencesEnvelop(apiPath: path, pathType: finishYourProfileSearchPath)
            return updateUserProfile
        } else {
            self.showAlert(title: "Oops!", message: "Please check your details")
            return nil
        }
    }
}

extension FinishYourProfileController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profileFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishYourProfileExpandedCell", for: indexPath) as! FinishYourProfileExpandedCell
            cell.fieldName.text = viewModel.profileFields[indexPath.row]
            cell.fieldValue.text = viewModel.getUserData(viewModel.profileFields[indexPath.row])
            cell.fieldValue.tag = indexPath.row
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishYourProfileCell", for: indexPath) as! FinishYourProfileCell
            cell.fieldValue.tag = indexPath.row
            cell.fieldName.text = viewModel.profileFields[indexPath.row]
            cell.fieldValue.text = viewModel.getUserData(viewModel.profileFields[indexPath.row])
            if viewModel.profileFields[indexPath.row] == "PHONE" {
                cell.fieldValue.keyboardType = UIKeyboardType.decimalPad
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return 110
        }
        return 70.0
    }
    
}


extension FinishYourProfileController {
    
    @IBAction func importImage(_ sender: UIButton)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //CAN ALSO ADD SOURCE TYPE: CAMERA
        //determined whether the user can edit their image before uploading
        image.allowsEditing = false
        isProfilePhotoSelected = (sender.tag == 1)
        self.present(image, animated: true) {
        }
    }
    
    //when the user has picked the image, checking if item can be converted to an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if isProfilePhotoSelected {
                profileImage.image = image
                userProfileViewwModel.uploadPhoto(photo: image, photoName: "ProfilePhoto")
                
            } else {
                coverImage.image = image
                userProfileViewwModel.uploadPhoto(photo: image, photoName: "CoverPhoto")
            }
            
        }
        else{
            print("picture failed to upload")
        }
        
        self.dismiss(animated: true, completion: nil)
        self.view.bringSubview(toFront: profileImage)
    }
    
}

extension FinishYourProfileController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldText = textField.text {
            viewModel.userEnteredData[viewModel.profileFields[textField.tag]] = textFieldText
        }
    }
}

extension FinishYourProfileController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let textViewtextViewtextView = textView.text {
            viewModel.userEnteredData[viewModel.profileFields[textView.tag]] = textViewtextViewtextView
        }
    }
}
