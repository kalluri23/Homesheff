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
    
    let data = [GenericField(name: "Sally", placeHolder: "FIRST NAME"),GenericField(name: "Lockwood", placeHolder: "LAST NAME"),GenericField(name: "sally.lockwood@gmail.com", placeHolder: "EMAIL"),GenericField(name: "Georgetown, Washington, D.C.", placeHolder: "LOCATION"),GenericField(name: "703-212-7854", placeHolder: "PHONE")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
