//
//  CheffDetailsViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

enum ProfileType {
    case cheffDetails
    case myAccount
}

class CheffDetailsViewController: UIViewController {

    @IBOutlet weak var chefServiceTableView: UITableView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var contactCheff: UIButton!
    @IBOutlet weak var contactButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var contactButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var cheffDetailsViewModel: CheffDetailsViewModel!

    var chefInfo: Chef?
    var profileType: ProfileType?
    var aboutSectionHeight: CGFloat = 0.0
    var aboutChef: String = ""
    var profileSections = [ProfileTableViewCellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chefServiceTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        cheffDetailsViewModel.chefInfo = self.chefInfo
        chefServiceTableView.register(ProfileHeaderCell.nib, forCellReuseIdentifier: ProfileHeaderCell.reuseIdentifier)
        chefServiceTableView.register(ProfileGenericTableViewCell.nib, forCellReuseIdentifier: ProfileGenericTableViewCell.reuseIdentifier)
        chefServiceTableView.register(AboutTableViewCell.nib, forCellReuseIdentifier: AboutTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding navigation since controller has its own navigation bar
        self.navigationController?.isNavigationBarHidden = true
        if profileType == ProfileType.myAccount {
            //Hide contact button when myaccount
            contactCheff.alpha = 0.0
            contactButtonHeight.constant = 0
            navigationTitleLbl.text = "My Profile"
        } else {
            self.profileTableViewBottom.constant = -55
            navigationTitleLbl.text = "\(chefInfo?.firstName ?? "")  \(chefInfo?.lastName ?? "") \n\(chefInfo?.location ?? "")"
        }
        profileSections  = cheffDetailsViewModel.prepareSections
       self.chefServiceTableView.reloadData()
        
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


extension CheffDetailsViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.profileSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.profileSections[section] {
            case .aboutType, .photoGalleryType, .headerType:
                return 1
            case .servicesType:
                return cheffDetailsViewModel.chefService.count
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch self.profileSections[ indexPath.section] {
            case .headerType:
                return 215
            case .aboutType:
                return  CGFloat(self.aboutSectionHeight)
            case .photoGalleryType:
                if let photosList = self.chefInfo?.photoGallery {
                    if photosList.count > 0 {
                        return 160
                    }else {
                        return 80
                    }
                }
                return 80
            case .servicesType:
                return  55
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.profileSections[section] {
            case .headerType:
                return 0
            default:
                return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.profileSections[ indexPath.section] {
            
            case .headerType:
                let headerCell: ProfileHeaderCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
                headerCell.profileHeading.text = chefInfo?.headertext
                headerCell.profileContact.text = "\(chefInfo?.email ?? "") - \(chefInfo?.phone ?? "")"
                headerCell.delegate = self
                if profileType != .myAccount {
                    headerCell.profileEditBtn.alpha = 0.0
                }
                DispatchQueue.global(qos: .background).async {
                    self.cheffDetailsViewModel.downloadImage(imageName: "\(self.chefInfo?.id ?? 0)_ProfilePhoto") { (image) in
                        DispatchQueue.main.async {
                            headerCell.profileImgView.image = image
                        }
                    }
                    self.cheffDetailsViewModel.downloadImage(imageName: "\(self.chefInfo?.id ?? 0)_CoverPhoto") { (image) in
                         DispatchQueue.main.async {
                             headerCell.profileBgView.image = image
                         }
                    }
                }
                
                return headerCell
            case .aboutType:
                let aboutCell: AboutTableViewCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
                aboutCell.delegate = self
                aboutCell.aboutChef = (chefInfo?.about)!
                let aboutHeight = chefInfo?.about?.height(withConstrainedWidth: (view.frame.width - 20), font: UIFont.systemFont(ofSize: 16))
                if CGFloat(100.0).isLess(than: aboutHeight!) {
                    aboutCell.showMoreButton = true
                    self.aboutSectionHeight = 155
                } else {
                    self.aboutSectionHeight = aboutHeight! + 20
                }
                return aboutCell
            case .photoGalleryType:
                let photoGalleryCell = tableView.dequeueReusableCell(withIdentifier: PhotoGalleryCell.reuseIdentifier, for: indexPath) as! PhotoGalleryCell
                if let photoList = self.chefInfo?.photoGallery {
                    photoGalleryCell.photoList = photoList
                }
                if profileType != .myAccount {
                    photoGalleryCell.isEditable = false
                }else {
                    photoGalleryCell.isEditable = true
                }
                photoGalleryCell.delegate = self
                 DispatchQueue.main.async {
                    photoGalleryCell.collectionView.reloadData()
                }
                return photoGalleryCell
            case .servicesType:
                let cell: ProfileGenericTableViewCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
                cell.chefDetails = cheffDetailsViewModel.chefService[indexPath.row]
                
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
            if profileType == .myAccount {
               return ""
            }else {
               return "Photos"
            }
            case .headerType:
                return ""
            case .servicesType:
                return  "Services"
        }
    }
}

extension CheffDetailsViewController: AboutCellDelegate {
    
    func viewMoreClicked() {
        self.navigationController?.pushViewController(AboutChefController.create(aboutChef: (chefInfo?.about)!), animated: true)
    }
}

extension CheffDetailsViewController: PhotoGalleryDelegate {
    
    func editPhotosClicked() {
        let vc = AddPhotosController.create()
        vc.hideRightBarButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CheffDetailsViewController: ProfileHeaderDelegate {
    func editProfileHeader() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
