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

    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var chefServiceTableView: UITableView!
    var chefServiceData = ChefServiceModel()
    var chefInfo: Chef?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setProfilePicture()
         title = chefInfo?.firstName
         emailLabel.text = "\(chefInfo?.email ?? "") - \(chefInfo?.phone ?? "")"
         chefServiceTableView.register(ProfileGenericTableViewCell.nib, forCellReuseIdentifier: ProfileGenericTableViewCell.reuseIdentifier)
    }
    
    private func setProfilePicture() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2;
        profilePictureImageView.clipsToBounds = true;
        profilePictureImageView.layer.borderWidth = 3.0;
        profilePictureImageView.layer.borderColor = UIColor.white.cgColor
    }
}


extension ChefDetailsViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chefServiceData.chefService.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 120
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProfileGenericTableViewCell = chefServiceTableView.dequeueReusableCell(for: indexPath)
            cell.chefDetails = chefServiceData.chefService[indexPath.row]
        
        cell.partCount1.isHidden = true
        cell.partyCount2.isHidden = true
        cell.partyCount3.isHidden = true
        
        if indexPath.row == 1 {
            cell.partCount1.isHidden = false
            cell.partyCount2.isHidden = false
            cell.partyCount3.isHidden = false
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SERVICES"
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if dataArray[indexPath.section][indexPath.row] == "Profile" {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "ChefDetailsVCID") as! ChefDetailsViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
//    }
    
}
