//
//  EditService.swift
//  Homesheff
//
//  Created by Anurag Pandey on 1/21/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

class EditServiceViewController : UIViewController, ServiceListDelegate {
    
    @IBOutlet weak var serviceTableView: UITableView!
    let viewModel = EditServiceViewModel()
    var serviceToEdit: SheffService?
    private var selectedServiceName: String?
    private var serviceDescription: String?
    private var isEditMode = false
    
    override func viewDidLoad() {
        
        if let serviceToEdit = serviceToEdit {
            selectedServiceName = serviceToEdit.name
            serviceDescription = serviceToEdit.description
            isEditMode = true
            
            let editButton = UIBarButtonItem(title: "Save",  style: .plain, target: self, action: #selector(updateService))
            self.navigationItem.rightBarButtonItem = editButton
        }
    }
    
    @objc func updateService(sender: AnyObject) {
        
        view.endEditing(true)
        if let selectedServiceName = selectedServiceName, selectedServiceName.count > 0 {
            callEditServiceAPI(selectedServiceName: selectedServiceName)
            return
        }
        
        showAlert(title: "", message: "Please select a service")
    }
    
    func selectedService(serviceName: String) {
        selectedServiceName = serviceName
        serviceTableView.reloadData()
    }
    
    @IBAction func deleteServiceAction(_ sender: Any) {
        callDeleteServiceAPI()
    }
    
    private func callEditServiceAPI(selectedServiceName: String) {
        
        guard let serviceId = serviceToEdit?.id else {
            return
        }
        viewModel.editService(envelop: viewModel.editServiceEnvelop(name: selectedServiceName, description: serviceDescription, serviceId: "\(serviceId)")) {  (success) in
            
            if success ?? false {
                self.showAlertWith(alertTitle: "Service edited successfully", action: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
    
    private func callDeleteServiceAPI() {
        
        guard let serviceId = serviceToEdit?.id else {
            return
        }
        
        viewModel.deleteService(envelop: viewModel.deleteServiceEnvelop(serviceId: "\(serviceId)")) {  (success) in
            if success ?? false {
                self.showAlertWith(alertTitle: "Service deleted successfully", action: {
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

extension EditServiceViewController: UITableViewDataSource, UITableViewDelegate {
    
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
                serviceCell.serviceDescription.text = serviceDescription
            }
            return serviceCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "serviceList", sender: self)
    }
    
}

extension EditServiceViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        serviceDescription = textField.text ?? ""
    }
}


