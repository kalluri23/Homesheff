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
    let findCheifViewModel = FindCheifViewModel()

    @IBOutlet weak var loadingIndoicator: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chefTableView.delegate = self
        chefTableView.dataSource = self
        loadingIndoicator.color = .black
        loadingIndoicator.type = .ballClipRotate
        loadingIndoicator.startAnimating()
        viewModelBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    func viewModelBinding()  {
        findCheifViewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.chefTableView.reloadData()
                self?.loadingIndoicator.stopAnimating()
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
            searchCell.textField.delegate = findCheifViewModel
            return searchCell
        }else {
            let cheffCell = tableView.dequeueReusableCell(withIdentifier: "ChefCell", for: indexPath) as! ChefCell
            cheffCell.chef = findCheifViewModel.cheifObjectAtIndex(index: indexPath.row)
            return cheffCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChefDetailsVCID") as! ChefDetailsViewController
           vc.chefInfo = findCheifViewModel.cheifObjectAtIndex(index: indexPath.row)
             tableView.deselectRow(at: indexPath, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 10)
        }else {
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        }
    }
}
