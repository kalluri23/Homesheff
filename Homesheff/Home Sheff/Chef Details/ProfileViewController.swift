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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChefDetails()
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
    
    private func updateChefDetails() {
        setProfileAndBgPicture()
        navigationTitleLbl.text = "\(chefInfo?.firstName ?? "")  \(chefInfo?.lastName ?? "")"
        emailLabel.text = "\(chefInfo?.email ?? "") - \(chefInfo?.phone ?? "")"
        headerLbl.text = "\(chefInfo?.headertext ?? "")"
        self.chefServiceTableView.reloadData()
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
        if chefInfo?.about != nil {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return chefServiceData.chefService.count
        case 1:
            return 1
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*if indexPath.row == 1{
            return 120
        }*/
        switch indexPath.section {
        case 0:
            return 55
        case 1:
            return CGFloat(self.aboutSectionHeight)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        switch indexPath.section {
            case 0:
                let profileCell: ProfileGenericTableViewCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
                profileCell.chefDetails = chefServiceData.chefService[indexPath.row]
                profileCell.partCount1.isHidden = true
                profileCell.partyCount2.isHidden = true
                profileCell.partyCount3.isHidden = true
                profileCell.servicePriceLabel.isHidden = true
                return profileCell
            
            case 1:
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
            default:
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "SERVICES"
            case 1:
                return "About"
            default:
                return ""
        }
        
    }
    
//    func calculateHeightOfAbout() -> CGFloat {
//
//    }
    
    
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
//        footerView.backgroundColor = UIColor.blue
//        return footerView
//    }
//
//    // set height for footer
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if dataArray[indexPath.section][indexPath.row] == "Profile" {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "ChefDetailsVCID") as! ChefDetailsViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
//    }
    
}

extension ProfileViewController: AboutCellDelegate {
    
    func viewMoreClicked() {
        self.navigationController?.pushViewController(AboutChefController.create(aboutChef: (chefInfo?.about)!), animated: true)
    }
}
