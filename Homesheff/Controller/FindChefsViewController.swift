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
    
    
    var chefs:[Chef] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        chefs = createArray()
        
        chefTableView.delegate = self
        chefTableView.dataSource = self
    }

    func createArray() -> [Chef]{
        
        var tempChefs: [Chef] = []
        
        let chef1 = Chef(chefImage: #imageLiteral(resourceName: "soma-kun"), chefName: "Soma", chefLocation: "Tokyo, Japan", chefRate: "25.00")
        let chef2 = Chef(chefImage: #imageLiteral(resourceName: "erina-sama"), chefName: "Erina", chefLocation: "Kyoto, Japan", chefRate: "35.00")
        let chef3 = Chef(chefImage: #imageLiteral(resourceName: "alice-nakiri"), chefName: "Alice", chefLocation: "Akina, Japan", chefRate: "40.00")
        let chef4 = Chef(chefImage: #imageLiteral(resourceName: "aldini-takumi"), chefName: "Takumi", chefLocation: "Osaka, Japan", chefRate: "29.00")

        tempChefs.append(chef1)
        tempChefs.append(chef2)
        tempChefs.append(chef3)
        tempChefs.append(chef4)
        
        return tempChefs
    }

}

extension FindChefsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chefs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chefRow = chefs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefCell") as! ChefCell
        
        cell.setChef(chef: chefRow)
        
        return cell
    }
    
}
