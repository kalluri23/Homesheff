//
//  ProfileViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit



// convert this into MVVM

enum ProfileType {
    case cheffDetails
    case myAccount
}

enum ProfileTableViewCellType {
    case photoGalleryType
    case aboutType
    case servicesType
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: CustomImageView!
    @IBOutlet weak var profileBgView: CustomImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var chefServiceTableView: UITableView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var contactCheff: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var profileEditButton: UIButton!
    @IBOutlet weak var contactButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var contactButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var contactButtonBottomConstraint: NSLayoutConstraint!
    
    var chefServiceData = ChefServiceModel()
    var chefInfo: Chef?
    var profileType: ProfileType?
    var aboutSectionHeight: CGFloat = 0.0
    var aboutChef: String = ""
    var profileSections = [ProfileTableViewCellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        chefServiceTableView.register(PhotoGalleryCell.nib, forCellReuseIdentifier: PhotoGalleryCell.reuseIdentifier)
        if profileType == ProfileType.cheffDetails {
             updateChefDetails()
        }
       
        chefServiceTableView.register(ProfileGenericTableViewCell.nib, forCellReuseIdentifier: ProfileGenericTableViewCell.reuseIdentifier)
        chefServiceTableView.register(AboutTableViewCell.nib, forCellReuseIdentifier: AboutTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding navigation since controller has its own navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        // Refresh profile after edit
        if profileType == ProfileType.myAccount {
            self.contactCheff.alpha = 0.0
            self.contactButtonHeight.constant = 0.0
            self.contactButtonConstraint.constant = 0.0
            self.contactButtonBottomConstraint.constant = 0.0
            self.chefInfo = Chef(user:User.defaultUser.currentUser!)
            updateChefDetails()
        } else {
             self.profileEditButton.alpha = 0.0
        }
    }
    
    private func getGalleryPhotos() {
        chefServiceData.getPhotosToGallery(envelop: chefServiceData.getPhotosToGalleryEnvelop(userId: (User.defaultUser.currentUser?.id)!)) { (photoData) in
            User.defaultUser.currentUser?.photoGallery = photoData
            self.chefInfo?.photoGallery = photoData
            self.updateSections()
            self.chefServiceTableView.reloadData()
        }
    }
    
    private func updateChefDetails() {
        setProfileAndBgPicture()
        navigationTitleLbl.text = "\(chefInfo?.firstName ?? "")  \(chefInfo?.lastName ?? "")"
        emailLabel.text = "\(chefInfo?.email ?? "") - \(chefInfo?.phone ?? "")"
        headerLbl.text = "\(chefInfo?.headertext ?? "")"
        updateSections()
        getGalleryPhotos()
        self.chefServiceTableView.reloadData()
    }
    
    private func updateSections() {
        if chefInfo?.about != nil && chefInfo?.photoGallery != nil && (chefInfo?.photoGallery!.count)! > 0 {
        self.profileSections = [.photoGalleryType,  .servicesType, .aboutType]
        } else if (chefInfo?.about != nil) {
        self.profileSections = [ .servicesType, .aboutType]
        } else {
        self.profileSections = [.servicesType]
        }
    }
    
    private func setProfileAndBgPicture() {
        
        if(chefInfo?.imageURL != nil) {
            chefServiceData.downloadImage(imageName: "\(chefInfo?.id ?? 0)_ProfilePhoto") { (image) in
                self.profilePictureImageView.image = image
                self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2
                self.profilePictureImageView.clipsToBounds = true;
                self.profilePictureImageView.layer.borderWidth = 3.0
                self.profilePictureImageView.layer.borderColor = UIColor.white.cgColor
            }
        }
        
        if(chefInfo?.coverURL != nil) {
            chefServiceData.downloadImage(imageName: "\(chefInfo?.id ?? 0)_CoverPhoto") { (image) in
               self.profileBgView.image = image
            }
        }
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //This is temp , need to change based on archi.
    
    @IBAction func contactSheffButoonAction(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose how you would like to contact this sheff", preferredStyle: .actionSheet)
        
        let call = UIAlertAction(title: "Call", style: .default){ [weak self] (alert) -> Void in
          
            self?.makeACall()
        }
        let iMessage = UIAlertAction(title: "iMessage", style: .default){ [weak self] (alert) -> Void in
            
            self?.sendAMessage()
        }
        let email = UIAlertAction(title: "Email", style: .default){ [weak self] (alert) -> Void in
            
            self?.sendAnEmail()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(call)
        optionMenu.addAction(iMessage)
        optionMenu.addAction(email)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func makeACall() {
        if let url = URL(string: "tel://\(chefInfo?.phone ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func sendAMessage() {
        guard let messageURL = URL(string: "sms:\(chefInfo?.phone ?? "")")
            else { return }
        if UIApplication.shared.canOpenURL(messageURL) {
            UIApplication.shared.open(messageURL)
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    private func sendAnEmail() {
        
        if let url = URL(string: "mailto:\(chefInfo?.email ?? "")") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}


extension ProfileViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.profileSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.profileSections[section] {
            case .aboutType, .photoGalleryType:
                return 1
            case .servicesType:
                return chefServiceData.chefService.count
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch self.profileSections[ indexPath.section] {
            
            case .aboutType:
                return  CGFloat(self.aboutSectionHeight)
            case .photoGalleryType:
                return 120
            case .servicesType:
                return  55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.profileSections[ indexPath.section] {
            
        case .aboutType:
            let aboutCell: AboutTableViewCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
            aboutCell.delegate = self
            aboutCell.aboutChef = (chefInfo?.about)!
            let aboutHeight = chefInfo?.about?.height(withConstrainedWidth: (view.frame.width - 20), font: UIFont.systemFont(ofSize: 16))
            if CGFloat(100.0).isLess(than: aboutHeight!) {
                aboutCell.showMoreButton = true
                self.aboutSectionHeight = 155
            } else {
                self.aboutSectionHeight = aboutHeight!
            }
            return aboutCell
        case .photoGalleryType:
            let photoGalleryCell = tableView.dequeueReusableCell(withIdentifier: PhotoGalleryCell.reuseIdentifier, for: indexPath) as! PhotoGalleryCell
            photoGalleryCell.photoList = (User.defaultUser.currentUser?.photoGallery)!
            photoGalleryCell.delegate = self
            return photoGalleryCell
        case .servicesType:
            let cell: ProfileGenericTableViewCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
            cell.chefDetails = chefServiceData.chefService[indexPath.row]
            
            cell.partCount1.isHidden = true
            cell.partyCount2.isHidden = true
            cell.partyCount3.isHidden = true
            cell.servicePriceLabel.isHidden = true
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        
        switch self.profileSections[section] {
            case .aboutType:
                return  "About"
            case .photoGalleryType:
                return "PHOTOS"
            case .servicesType:
                return  "SERVICES"
        }
        
    }
    
}

extension ProfileViewController: AboutCellDelegate {
    
    func viewMoreClicked() {
        self.navigationController?.pushViewController(AboutChefController.create(aboutChef: (chefInfo?.about)!), animated: true)
    }
}

extension ProfileViewController: PhotoGalleryDelegate {
    
    func editPhotosClicked() {
        
        let vc = AddPhotosController.create(photoData: (User.defaultUser.currentUser?.photoGallery)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
