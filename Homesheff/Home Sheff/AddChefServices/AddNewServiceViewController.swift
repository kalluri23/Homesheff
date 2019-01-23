//
//  AddNewService.swift
//  Homesheff
//
//  Created by Anurag Pandey on 1/15/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

class AddNewServiceViewController : UIViewController, ServiceListDelegate {
    
    @IBOutlet weak var serviceTableView: UITableView!
    let viewModel = AddNewServiceViewModel()
    private var selectedServiceName: String?
    private var serviceDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectedService(serviceName: String) {
        selectedServiceName = serviceName
        serviceTableView.reloadData()
    }
    
    @IBAction func addServiceAction(_ sender: Any) {
        
        view.endEditing(true)
        if let selectedServiceName = selectedServiceName, selectedServiceName.count > 0 {
            callAddServiceAPI(selectedServiceName: selectedServiceName)
            return
        }
        
        showAlert(title: "", message: "Please select a service")
    }
    
    private func callAddServiceAPI(selectedServiceName: String) {
        
        viewModel.addService(envelop: viewModel.addServiceEnvelop(name: selectedServiceName, description: serviceDescription)) {  (service) in
            
            if service?.id != nil {
                self.showAlertWith(alertTitle: "Service added successfully", action: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "serviceList" {
            if let serviceListVC = segue.destination as? ServiceListViewController {
                serviceListVC.delegate = self
            }
        }
    }
}

extension AddNewServiceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0, let serviceCell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell") as? ServiceNameCell {
            if let selectedServiceName = selectedServiceName, selectedServiceName.count > 0 {
                serviceCell.serviceName.text = selectedServiceName
                serviceCell.serviceName.textColor = view.tintColor
            }
            return serviceCell
            
        } else if indexPath.row == 1, let serviceCell = tableView.dequeueReusableCell(withIdentifier: "ServiceDescriptionCell") as? ServiceDescriptionCell {
            if let serviceDescription = serviceDescription, serviceDescription.count > 0 {
                serviceCell.serviceDescription.text = selectedServiceName
            }
            return serviceCell
        }
        return UITableViewCell()
    }
    
}

extension AddNewServiceViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        serviceDescription = textField.text ?? ""
    }
}

