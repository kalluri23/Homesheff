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
    
    let dataArray = [["Profile"],["Version","Privacy Policy","Terms of Services","Sign Out"]]
    @IBOutlet weak var nameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userAccountVC.register(UserAccountCell.nib, forCellReuseIdentifier: UserAccountCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    private func didTapTermsAndCondition(isTermsAndCondition: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionViewControllerID") as! TermsAndConditionViewController
           vc.isTermsAndCondition = isTermsAndCondition
           self.present(vc, animated: true, completion: nil)
    }
    
    private func didTapSignOut() {
        let viewControllers = self.navigationController?.viewControllers
        for viewController in viewControllers! {
            UserDefaults.standard.set(false, forKey: "userLoggedIn")
            if viewController.isKind(of: SignInViewController.self) {
                UserDefaults.standard.set(false, forKey: "userLoggedIn")
                self.navigationController?.popToViewController(viewController, animated: true)
            } else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "SignInID") as! SignInViewController
                let navigationController = UINavigationController(rootViewController: vc)
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                UINavigationBar.appearance().barTintColor = UIColor(red: 136/255.0, green: 176/255.0, blue: 74/255.0, alpha: 1.0)
                navigationController.navigationBar.tintColor = UIColor.white;
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
                appdelegate.window!.rootViewController = navigationController
             }
        }
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
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserAccountCell = userAccountVC.dequeueReusableCell(for: indexPath)
        cell.nameLable.text = dataArray[indexPath.section][indexPath.row]
        
        cell.detailedLabel.isHidden = true
        cell.accessoryType = .none
        
        // This is temp , need to tie state with enum and data source
        if dataArray[indexPath.section][indexPath.row] == "Profile" {
            cell.accessoryType = .disclosureIndicator
        }
        
        if dataArray[indexPath.section][indexPath.row] == "Version" {
            cell.detailedLabel.isHidden = false
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            cell.detailedLabel.text = appVersion
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
        
        // This is temp , need to tie state with enum and data source
        if dataArray[indexPath.section][indexPath.row] == "Profile" {
            
            if (User.defaultUser.currentUser != nil) && (User.defaultUser.currentUser?.isChef)! {
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                vc.profileType = .myAccount
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
               let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            // vc.chefInfo = Chef(user:User.defaultUser.currentUser!)
//
//            let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        }
        else if dataArray[indexPath.section][indexPath.row] == "Terms of Services" {
            self.didTapTermsAndCondition(isTermsAndCondition: true)
        }
        else if dataArray[indexPath.section][indexPath.row] == "Privacy Policy" {
            self.didTapTermsAndCondition(isTermsAndCondition: false)
        }
        else if dataArray[indexPath.section][indexPath.row] == "Sign Out" {
            didTapSignOut()
        }
        
    }
    
}

