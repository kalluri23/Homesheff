//
//  AddServicesViewController.swift
//  Homesheff
//
//  Created by Anurag Pandey on 1/13/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

class AddServicesViewController: UIViewController {

    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var noServicesView: UIView!
    private let viewModel = AddServicesViewModel()
    private var serviceList: [SheffService]?
    private var serviceToEdit = SheffService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callGetServicesAPI()
    }
    
    private func callGetServicesAPI() {
        viewModel.getServices(envelop: viewModel.getServicesEnvelop()) { [unowned self] serviceList in
            self.serviceList = serviceList
            self.servicesTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editServiceVC = segue.destination as? EditServiceViewController {
            editServiceVC.serviceToEdit = serviceToEdit
        }
    }
    
    @objc private func nextTapped() {
        
        self.performSegue(withIdentifier: "AddPhotos", sender: self)
    }
}

extension AddServicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let addedServiceCell: AddedServiceCell = tableView.dequeueReusableCell(withIdentifier: "AddedServiceCell") as? AddedServiceCell {
            
            addedServiceCell.serviceName.text = serviceList?[indexPath.row].name
            addedServiceCell.serviceDescription.text = serviceList?[indexPath.row].description
            return addedServiceCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let serviceListObject = serviceList?[indexPath.row] {
            serviceToEdit = serviceListObject
        }
        self.performSegue(withIdentifier: "editService", sender: self)
    }
}
