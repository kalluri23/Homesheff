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
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    var findCheifViewModel :FindCheifViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chefTableView.delegate = self
        chefTableView.dataSource = self
        loadingIndicator.color = .black
        loadingIndicator.type = .ballClipRotate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        findCheifViewModel = FindCheifViewModel()
        loadingIndicator.startAnimating()
        viewModelBinding()
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    func viewModelBinding()  {
        findCheifViewModel?.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.chefTableView.reloadData()
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
}

extension FindChefsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findCheifViewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChefCell = tableView.dequeueReusableCell(for: indexPath)
        cell.chef = findCheifViewModel?.cheifObjectAtIndex(index: indexPath.row)
        if (cell.chef?.imageURL != nil) {
            findCheifViewModel?.downloadImage(imageName: "\(cell.chef?.id ?? 0)_ProfilePhoto", completion: { (image) in
                cell.cheffImageView.image = image
                self.findCheifViewModel?.prepareProfileImageView(imageView: cell.cheffImageView)
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChefDetailsVCID") as! ChefDetailsViewController
        vc.chefInfo = findCheifViewModel?.cheifObjectAtIndex(index: indexPath.row)
             tableView.deselectRow(at: indexPath, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
}
