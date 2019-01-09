//
//  FindChefsViewController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/16/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FindChefsViewController: UIViewController {
    
    @IBOutlet weak var chefTableView: UITableView!
    @IBOutlet weak var findCheifViewModel: FindCheifViewModel!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    
    var profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        viewModelBinding()
        chefTableView.delegate = self
        chefTableView.dataSource = self
        loadingIndicator.color = .black
        loadingIndicator.type = .ballClipRotate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // comment below since findchief is already an outlet
        self.findCheifViewModel.reloadTableView!()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    func viewModelBinding()  {
        findCheifViewModel?.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                //Reload only content section to do not resign first responser
                self?.chefTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
}

extension FindChefsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return findCheifViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return findCheifViewModel.numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! FindChefCell
            return searchCell
        } else {

            let cheffCell = tableView.dequeueReusableCell(withIdentifier: "ChefCell", for: indexPath) as! ChefCell
            cheffCell.chef = findCheifViewModel?.cheifObjectAtIndex(index: indexPath.row)
            if (cheffCell.chef?.imageURL != nil) {
                findCheifViewModel?.downloadImage(imageName: "\(cheffCell.chef?.id ?? 0)_ProfilePhoto", completion: { (image) in
                    cheffCell.cheffImageView.image = image
                    self.findCheifViewModel?.prepareProfileImageView(imageView: cheffCell.cheffImageView)
                })
            } else {
                cheffCell.cheffImageView.image = UIImage(named: "sheffs_list_placeholder")
            }
             return cheffCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
        self.loadingIndicator.startAnimating()
        profileViewModel.getPhotosToGallery(envelop:
             profileViewModel.getPhotosToGalleryEnvelop(userId: (User.defaultUser.currentUser?.id)!)) { (photoData) in
                self.loadingIndicator.stopAnimating()
                User.defaultUser.currentUser?.photoGallery = photoData
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                vc.chefInfo = self.findCheifViewModel.cheifObjectAtIndex(index: indexPath.row)
                vc.profileType = .cheffDetails
                vc.hidesBottomBarWhenPushed = true
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 10)
        }else {
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        }
    }
}
