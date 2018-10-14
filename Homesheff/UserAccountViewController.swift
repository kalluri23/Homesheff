//
//  UserAccountViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController {
    
    // Change it to VM later //*
    @IBOutlet weak var userAccountVC: UITableView!
    
    let dataArray = [["Profile"],["Version","Privacy Policy","Terms of Services"]]
    @IBOutlet weak var nameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

      userAccountVC.register(UserAccountCell.nib, forCellReuseIdentifier: UserAccountCell.reuseIdentifier)
    }

}

extension UserAccountViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserAccountCell = userAccountVC.dequeueReusableCell(for: indexPath)
        cell.nameLable.text = dataArray[indexPath.section][indexPath.row]
        
        cell.detailedLabel.isHidden = true
        cell.accessoryType = .none
        
        if dataArray[indexPath.section][indexPath.row] == "Profile" {
            cell.accessoryType = .disclosureIndicator
        }
        
        if dataArray[indexPath.section][indexPath.row] == "Version" {
            cell.detailedLabel.isHidden = false
            cell.detailedLabel.text = "1.0.1"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "GENERAL"
        }
        return "SETTINGS"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray[indexPath.section][indexPath.row] == "Profile" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

