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
    @IBOutlet weak var findCheifViewModel: FindCheifViewModel!
    @IBOutlet weak var profileViewModel: CheffDetailsViewModel!
    @IBOutlet weak var locationSearchViewModel: LocationSearchViewModel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    
    var locationSearchisActive = false
    var selectedLocation: (lat: String,lon: String) = ("","")
    
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
        setCurrentLocation()
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
        LocationManager.shared.requestForLocation()
        self.locationTextField.text = "Current Location"
        self.selectedLocation = ("\(LocationManager.shared.currentLocation.coordinate.latitude)", "\(LocationManager.shared.currentLocation.coordinate.longitude)")
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
            locationCell.location = locationSearchViewModel.locations[indexPath.row]
            return locationCell
        }else {
            switch findCheifViewModel.searchType {
            case .searchByFirstName:
                let cheffCell = tableView.dequeueReusableCell(withIdentifier: "ChefCell", for: indexPath) as! ChefCell
                cheffCell.chef = findCheifViewModel.cheifObjectAtIndex(index: indexPath.row)
                return cheffCell
            case .searchByLocation:
                let cheffCell = tableView.dequeueReusableCell(withIdentifier: "ChefLocationCell", for: indexPath) as! CheffLocationCell
                cheffCell.chefService = findCheifViewModel.cheifServiceObjectAt(index: indexPath.row)
                return cheffCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if locationSearchisActive {
            let selectedLocation = locationSearchViewModel.locations[indexPath.row]
            locationTextField.text = "\(selectedLocation.city),\(selectedLocation.state)"
            locationTextField.resignFirstResponder()
            self.selectedLocation.lat = selectedLocation.latitude
            self.selectedLocation.lon = selectedLocation.longitude
            locationSearchisActive = false
            
        }else {
            if self.findCheifViewModel.searchType == .searchByFirstName {
                self.loadingIndicator.startAnimating()
                var selectedCheffObject = self.findCheifViewModel.cheifObjectAtIndex(index: indexPath.row)
                profileViewModel.getPhotosToGallery(envelop:
                profileViewModel.getPhotosToGalleryEnvelop(userId: selectedCheffObject.id)) { (photoData) in
                    self.loadingIndicator.stopAnimating()
                    selectedCheffObject.photoGallery = photoData
                    self.performSegue(withIdentifier: UIStoryboardSegue.cheffDetailsSegue, sender: selectedCheffObject)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
    }
}

extension FindChefsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == kFindCheffTextFieldTag {
            self.locationSearchisActive = false
            if let _ = locationTextField.text {// Search with custom location
                self.findCheifViewModel.searchType = .searchByLocation
                if let chefFieldText = textField.text {
                    let searchText = chefFieldText + string
                    self.findCheifViewModel.searchServices(searchText: searchText, latitude: self.selectedLocation.lat, longitude: self.selectedLocation.lon)
                }else {
                    self.findCheifViewModel.searchServices(searchText: string, latitude: self.selectedLocation.lat, longitude: self.selectedLocation.lon)
                }
            }else {//Search with current location
                self.findCheifViewModel.searchType = .searchByFirstName
                if let chefFieldText = textField.text {
                    let searchText = chefFieldText + string
                    self.findCheifViewModel.searchListOfUser(matchingString: searchText)
                }else {
                    self.findCheifViewModel.searchListOfUser(matchingString: string)
                }
            }
            
        }else if textField.tag == kSearchLocationTextFieldTag {//Search a location
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
            self.nameTextField.text = nil
            self.findCheifViewModel.searchType = .searchByFirstName
            self.findCheifViewModel.searchListOfUser()
            return false
        }
        if textField.tag == kSearchLocationTextFieldTag {
            self.locationTextField.resignFirstResponder()
            self.locationTextField.text = "Current Location"
            self.selectedLocation = ("\(LocationManager.shared.currentLocation.coordinate.latitude)", "\(LocationManager.shared.currentLocation.coordinate.longitude)")
            self.findCheifViewModel.searchType = .searchByFirstName
            self.locationSearchisActive = false
            self.findCheifViewModel.searchListOfUser()
            return false
        }
        return true
    }
}
