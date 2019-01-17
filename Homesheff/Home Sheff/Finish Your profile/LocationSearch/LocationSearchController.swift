//
//  LocationSearchController.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/15/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

protocol LocationSelectionDelegate: class {
    func userDidselect(location: Location)
}

class LocationSearchController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationSearchViewModel: LocationSearchViewModel!
    @IBOutlet weak var searchBar: UISearchBar!
    weak var locationSelectDelegate: LocationSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBinding()
    }
    
    deinit {
        self.locationSelectDelegate = nil
    }
    
    func viewModelBinding()  {
        locationSearchViewModel.reloadTableView = { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension LocationSearchController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationSearchViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationSearchViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        locationCell.location = locationSearchViewModel.locations[indexPath.row]
        return locationCell
    }
}

extension LocationSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true, completion: {[unowned self] in
            if let delegate = self.locationSelectDelegate {
                delegate.userDidselect(location: self.locationSearchViewModel.locations[indexPath.row])
            }
        })
    }
}

extension LocationSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        locationSearchViewModel.searchLocation(query:searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
