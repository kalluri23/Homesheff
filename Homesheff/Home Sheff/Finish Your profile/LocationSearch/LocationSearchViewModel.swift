//
//  LocationSearchViewModel.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/15/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchViewModel: NSObject {

    // private let apiHandler = APIManager()
    
    var reloadTableView: (() -> Void)?
    
    var searchResults = [MKMapItem]()

    /// return default number of section
    var numberOfSections: Int {
        return 1
    }
    
    /// returns counts of cheif to generate the rows
    var numberOfRows: Int {
        return searchResults.count
    }
    override init() {
        super.init()
    }
    
    func searchLocation(query:String) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (response, error) in
            if response?.mapItems.count != nil {
                self.searchResults = (response?.mapItems)!
                self.reloadTableView?()
            }
        }
    }
}
