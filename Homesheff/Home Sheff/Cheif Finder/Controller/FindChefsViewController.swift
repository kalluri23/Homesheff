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
        
        self.title = "Chef"
        chefTableView.delegate = self
        chefTableView.dataSource = self
        loadingIndoicator.color = .black
        loadingIndoicator.type = .ballClipRotate
        loadingIndoicator.startAnimating()
        viewModelBinding()
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findCheifViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChefCell = tableView.dequeueReusableCell(for: indexPath)
        cell.chef = findCheifViewModel.cheifObjectAtIndex(index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChefDetailsVCID") as! ChefDetailsViewController
           vc.chefInfo = findCheifViewModel.cheifObjectAtIndex(index: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
