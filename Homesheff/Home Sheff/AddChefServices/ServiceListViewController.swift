//
//  ServiceListViewController.swift
//  Homesheff
//
//  Created by Anurag Pandey on 1/16/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceListDelegate
{
    func selectedService(serviceName: String)
}

class ServiceListViewController: UIViewController {
    
    var delegate: ServiceListDelegate?
    @IBOutlet weak var serviceListTableView: UITableView!
    private let serviceList = ["Meal Planning", "Meal Preparation", "Grocery Shopping",
                               "Dietary Planning", "Dietary Planning(Gluten free)", "Catering", "Health and Wellness Coaching",
                               "Grocery Shopping Lessons", "Meal Planning Lessons", "Cooking Classes", "Transition services(Cleansing services)", "Transition services(Detoxing)", "Transition services(Veganizing the Kitchen)", "Holistic Healing", "Baking Services", "Weight Loss", "Muscle Building", "Sports and Recovery", "Disease Prevention and Reversal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Service Name"
        
    }
}

extension ServiceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let serviceCell: ServiceListCell = tableView.dequeueReusableCell(withIdentifier: "ServiceListCell") as? ServiceListCell {
            serviceCell.serviceName.text = serviceList[indexPath.row]
            return serviceCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // Adding manual delay to make UI look good
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.selectedService(serviceName: self.serviceList[indexPath.row])
        }
    }
  
}
