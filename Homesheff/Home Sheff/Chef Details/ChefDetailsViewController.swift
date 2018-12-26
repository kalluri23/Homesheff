//
//  ChefDetailsViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

// convert this into MVVM

class ChefDetailsViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: CustomImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var chefServiceTableView: UITableView!

    @IBOutlet weak var navigationTitleLbl: UILabel!
    var chefServiceData = ChefServiceModel()
    var chefInfo: Chef?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setProfilePicture()
         navigationTitleLbl.text = "\(chefInfo?.firstName ?? "")  \(chefInfo?.lastName ?? "")"
         emailLabel.text = "\(chefInfo?.email ?? "") - \(chefInfo?.phone ?? "")"
         chefServiceTableView.register(ProfileGenericTableViewCell.nib, forCellReuseIdentifier: ProfileGenericTableViewCell.reuseIdentifier)
        chefServiceTableView.register(PhotoGalleryCell.nib, forCellReuseIdentifier: PhotoGalleryCell.reuseIdentifier)
        
    }
    
    private func setProfilePicture() {
        profilePictureImageView.loadImageWithUrlString(urlString: chefInfo?.imageURL ?? "")
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2;
        profilePictureImageView.clipsToBounds = true;
        profilePictureImageView.layer.borderWidth = 3.0;
        profilePictureImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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


extension ChefDetailsViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return chefServiceData.chefService.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 120
            default:
                return 55

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                 let photoGalleryCell = tableView.dequeueReusableCell(withIdentifier: PhotoGalleryCell.reuseIdentifier, for: indexPath) as! PhotoGalleryCell
                 photoGalleryCell.photoList = []
                 return photoGalleryCell
            case 1:
                let cell: ProfileGenericTableViewCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
                cell.chefDetails = chefServiceData.chefService[indexPath.row]
                
                cell.partCount1.isHidden = true
                cell.partyCount2.isHidden = true
                cell.partyCount3.isHidden = true
                cell.servicePriceLabel.isHidden = true
             return cell
            default:
               return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        switch section {
        case 0:
            return "SERVICES"
        case 1:
            return "PHOTOS"
        default:
            return ""
        }
    }
    
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
