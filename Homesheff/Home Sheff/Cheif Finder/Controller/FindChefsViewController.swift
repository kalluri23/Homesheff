//
//  FindChefsViewController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/16/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class FindChefsViewController: UIViewController {
    
    @IBOutlet weak var chefTableView: UITableView!
    let findCheifViewModel = FindCheifViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chefTableView.delegate = self
        chefTableView.dataSource = self
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
    
}
