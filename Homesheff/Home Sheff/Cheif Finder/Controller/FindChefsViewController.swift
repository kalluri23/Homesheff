//
//  FindChefsViewController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/16/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MapKit

class FindChefsViewController: UIViewController {
    
    @IBOutlet weak var chefTableView: UITableView!
    @IBOutlet weak var findCheifViewModel: FindCheifViewModel!
    @IBOutlet weak var profileViewModel: CheffDetailsViewModel!
    @IBOutlet weak var locationSearchViewModel: LocationSearchViewModel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchTypeControl: UISegmentedControl!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    
    var locationSearchisActive = false
    var selectedLocation: String = "Washington DC"
    
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
        nameTextField.delegate = self
        if(locationTextField.text == "" || locationTextField.text == nil) {
            setCurrentLocation()
        }
        self.locationSearchisActive = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier, segueIdentifier == UIStoryboardSegue.cheffDetailsSegue, let cheffObject = sender as? Chef {
            let cheffDetailVC = segue.destination as! CheffDetailsViewController
            cheffDetailVC.chefInfo = cheffObject
            cheffDetailVC.profileType = .cheffDetails
        }
    }
    
    private func viewModelBinding()  {
        findCheifViewModel?.reloadTableView = { [unowned self] in
            DispatchQueue.main.async {
                self.chefTableView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
        locationSearchViewModel.reloadTableView = findCheifViewModel.reloadTableView
    }
    
    private func setCurrentLocation() {
         self.locationTextField.text = "Current Location"
         // self.selectedLocation = ("\(LocationManager.shared.currentLocation.coordinate.latitude)", "\(LocationManager.shared.currentLocation.coordinate.longitude)")
    }
    
    
    @IBAction func didSelectSegment(_ sender: Any) {
        
        if (nameTextField.text != nil &&  nameTextField.text != "") {
            self.searchBySelection(searchText: nameTextField.text!)
        } else {
            self.loadingIndicator.startAnimating()
            self.findCheifViewModel.getSheffsByLocation(location: self.selectedLocation) { (status) in
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
}

extension FindChefsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationSearchisActive ? locationSearchViewModel.numberOfRows : findCheifViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if locationSearchisActive {
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            let mapItem = locationSearchViewModel.searchResults[indexPath.row]
            locationCell.location = mapItem.placemark
            return locationCell
        }else {
            switch findCheifViewModel.searchType {
                case .searchByName,
                .searchByLocation, .searchByServices:
                    let cheffCell = tableView.dequeueReusableCell(withIdentifier: "ChefLocationCell", for: indexPath) as! CheffLocationCell
                    cheffCell.chefService = findCheifViewModel.cheifServiceObjectAt(index: indexPath.row)
                    return cheffCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if locationSearchisActive {
            let selectedLocation = locationSearchViewModel.searchResults[indexPath.row]
            self.selectedLocation = "\(selectedLocation.placemark.locality ?? ""),\(selectedLocation.placemark.administrativeArea ?? "")"
            locationTextField.text = self.selectedLocation
            locationTextField.resignFirstResponder()
            locationSearchisActive = false
            if nameTextField.text != nil &&  nameTextField.text != "" && nameTextField.text != " " {
                // searchBySelection(searchText:  nameTextField.text!)
            } else {
                self.loadingIndicator.startAnimating()
                self.findCheifViewModel.getSheffsByLocation(location: self.selectedLocation) { (status) in
                    self.loadingIndicator.stopAnimating()
                }
            }
            
        } else {
                self.loadingIndicator.startAnimating()
                let selectedCheffObject = self.findCheifViewModel.cheifServiceObjectAt(index: indexPath.row)
                self.findCheifViewModel.getSheffById(envelop: self.findCheifViewModel.getSheffByIdEnvelop(userId: Int(selectedCheffObject.id) ?? 0), completion: {[unowned self] (sheff, isSuccess) in
                    self.loadingIndicator.stopAnimating()
                    if isSuccess, var sheffObject = sheff {
                        self.loadingIndicator.startAnimating()
                        self.profileViewModel.getPhotosToGallery(envelop:
                        self.profileViewModel.getPhotosToGalleryEnvelop(userId: sheffObject.id)) { (photoData) in
                            self.loadingIndicator.stopAnimating()
                            sheffObject.photoGallery = photoData
                            self.performSegue(withIdentifier: UIStoryboardSegue.cheffDetailsSegue, sender: sheffObject)
                        }
                    }
                })
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
    func searchBySelection(searchText: String) {
            if searchTypeControl.selectedSegmentIndex == 0 {
                self.findCheifViewModel.searchType = .searchByName
                self.loadingIndicator.startAnimating()
                self.findCheifViewModel.searchCheffByName(searchText: searchText, location: self.selectedLocation) { (status) in
                    self.loadingIndicator.stopAnimating()
                }
            } else if  searchTypeControl.selectedSegmentIndex == 1 {
                self.findCheifViewModel.searchType = .searchByServices
                self.loadingIndicator.startAnimating()
                self.findCheifViewModel.searchServices(searchText: searchText, location: self.selectedLocation) { (status) in
                    self.loadingIndicator.stopAnimating()
                }
            }
    }
}

extension FindChefsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == kFindCheffTextFieldTag {
             self.locationSearchisActive = false
            if let chefFieldText = textField.text {
                let searchText = chefFieldText + string
                self.searchBySelection(searchText: searchText)
            } else {
                self.searchBySelection(searchText: string)
            }
        } else if textField.tag == kSearchLocationTextFieldTag {//Search a location
            self.locationSearchisActive = true
            if let locationText = textField.text {
                let searchText = locationText + string
                self.locationSearchViewModel.searchLocation(query: searchText)
            }else {
                self.locationSearchViewModel.searchLocation(query: string)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.tag == kFindCheffTextFieldTag {
            self.nameTextField.resignFirstResponder()
            self.nameTextField.text = ""
            self.findCheifViewModel.searchType = .searchByName
            self.loadingIndicator.startAnimating()
            self.findCheifViewModel.getSheffsByLocation(location: self.selectedLocation) { (status) in
                 self.loadingIndicator.stopAnimating()
            }
            return false
        }
        if textField.tag == kSearchLocationTextFieldTag {
            self.locationTextField.resignFirstResponder()
            self.locationTextField.text = ""
            self.selectedLocation = "Washington DC"
            self.loadingIndicator.startAnimating()
            self.findCheifViewModel.getSheffsByLocation(location: self.selectedLocation) { (status) in
                self.loadingIndicator.stopAnimating()
            }
            return false
        }
        return true
    }
}
