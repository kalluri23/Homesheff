//
//  FinishYourProfileController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit


class FinishYourProfile : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    let userProfileViewwModel = UserProfileViewModel()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    //following fields have their own search page
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addServicesTextField: UITextField!
    @IBOutlet weak var ratesTextField: UITextField!
    @IBOutlet weak var finishYourProfileTableView: UITableView!
    
    let viewModel = FinishYourProfileViewModel()
    private var isProfilePhotoSelected = false
    
    var location: String?
    var services: String?
    var rates: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveUserProfile))
        
        //        firstNameTextField.setPadding()
        //        firstNameTextField.setBottomBorderLightGray()
        //
        //        lastNameTextField.setPadding()
        //        lastNameTextField.setBottomBorderLightGray()
        //
        //        emailTextField.setPadding()
        //        emailTextField.setBottomBorderLightGray()
        //
        //        locationTextField.setPadding()
        //        locationTextField.setBottomBorderLightGray()
        //
        //        phoneTextField.setPadding()
        //        phoneTextField.setBottomBorderLightGray()
        //
        //        addServicesTextField.setPadding()
        //        addServicesTextField.setBottomBorderLightGray()
        
        
        // locationTextField.delegate = self
        //addServicesTextField.delegate = self
        //ratesTextField.delegate = self
        
        
        finishYourProfileTableView.register(GenericFieldsCellTableViewCell.nib, forCellReuseIdentifier: GenericFieldsCellTableViewCell.reuseIdentifier)
        finishYourProfileTableView.register(SelectedServiceTableViewCell.nib, forCellReuseIdentifier: SelectedServiceTableViewCell.reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //  locationTextField.text = location
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
       // performSegue(withIdentifier: "locationPage", sender: self)
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "locationPage" {
            
            let locationController = segue.destination as! LocationServicesRatesViewController
            
            locationController.location = locationTextField.text
        }
    }
    
}


extension FinishYourProfile: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fields[section].rowCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.fields[indexPath.section]
        
        switch item.type {
        case .genericField:
            if let item = item as? FinishGenericFieldItem {
                let cell: GenericFieldsCellTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.geneircFields = item.genericData[indexPath.row]
                cell.genericField.tag = indexPath.row
                cell.genericField.delegate = self
                return cell
            }
            
        case .selectedServicesCollectionViewField:
            if let item = item as? SelectedServiceFieldItem {
                let cell: SelectedServiceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                print(item.rowCount)
                cell.services = item.addServices
                cell.genericField.tag = 101 // Taking a static tag for now
                cell.genericField.delegate = self
                return cell
            }
            
            
        case .suggestedServicesCollectionViewField:
            print("here we have to add the item")
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.fields[indexPath.section]
        
        switch item.type {
        case .selectedServicesCollectionViewField:
            return 200.0
        default:
            return 56.0
        }
    }
}

extension FinishYourProfile {
    
    private func finishUserProfileEnvelop() -> Requestable? {
        
        let user = User.defaultUser.currentUser
        if let data = (viewModel.fields[0] as? FinishGenericFieldItem)?.genericData {
            let updateUserProfileSearchPath = ServicePath.updateUserPreferenceCall(firstName: data[0].name , lastName: data[1].name, headline: data[2].name, phoneNo: data[5].name, location: data[4].name, zipCode: "", services: (viewModel.fields[1] as? SelectedServiceFieldItem)?.addServices.genericField.name , isChef: user?.isChef, isCustomer: user?.isCustomer)
            let path = "updateUserPreferences/" + "\(user?.id ?? 0)"
            let updateUserProfile = UpdateUserPreferencesEnvelop(apiPath: path, pathType: updateUserProfileSearchPath)
            return updateUserProfile
        }
        return nil
    }
    
    @objc func saveUserProfile() {
        
        view.endEditing(true)
        guard let finishUserProfileEnvelop = finishUserProfileEnvelop()  else {
            return
        }
        viewModel.finishUserProfile(envelop: finishUserProfileEnvelop) { (success) in
            if success {
                let baseTabbar = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
                self.present(baseTabbar, animated: false, completion: {
                    
                })
            } else {
                 self.showAlert(title: "Oops!", message: "Please check your details")
            }
        }
    }
}

extension FinishYourProfile: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldText = textField.text {
            
            if textField.tag == 101 {
                (viewModel.fields[1] as? SelectedServiceFieldItem)?.addServices.genericField.name = textFieldText
                return
            }
            
            if let data = (viewModel.fields[0] as? FinishGenericFieldItem)?.genericData {
                var currentData = data[textField.tag]
                currentData.name = textFieldText
                (viewModel.fields[0] as? FinishGenericFieldItem)?.genericData[textField.tag] = currentData
            }
        }
    }
}

extension FinishYourProfile {
    
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
            //after it is complete
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
