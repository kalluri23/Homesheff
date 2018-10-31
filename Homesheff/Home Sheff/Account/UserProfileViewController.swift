//
//  UserProfileViewController.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userProfileTableView: UITableView!
    @IBOutlet weak var userProfilePicture: UIImageView!
    // we have to change these value to MVVM later
    //TODO :----
    let chefUser = User.defaultUser.currentUser
    
    var data = [GenericField]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       data =  [GenericField(name: self.chefUser?.firstName ?? "", placeHolder: "FIRST NAME"),GenericField(name: self.chefUser?.lastName ?? "", placeHolder: "LAST NAME"),GenericField(name: self.chefUser?.email ?? "", placeHolder: "EMAIL"),GenericField(name: "Georgetown, Washington, D.C.", placeHolder: "LOCATION"),GenericField(name: self.chefUser?.phone ?? "", placeHolder: "PHONE")]
        userProfileTableView.register(UserProfileTableViewCell.nib, forCellReuseIdentifier: UserProfileTableViewCell.reuseIdentifier)
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
        cell.valueLabel.text = data[indexPath.row].name
        
        return cell
    }
}
