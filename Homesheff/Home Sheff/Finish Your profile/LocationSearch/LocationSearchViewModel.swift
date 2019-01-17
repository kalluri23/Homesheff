//
//  LocationSearchViewModel.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/15/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class LocationSearchViewModel: NSObject {
    private let apiHandler = APIManager()
    var reloadTableView: (() -> Void)?
    
    var locations = [Location]()
    /// return default number of section
    var numberOfSections: Int {
        return 1
    }
    
    /// returns counts of cheif to generate the rows
    var numberOfRows: Int {
        return locations.count
    }
    override init() {
        super.init()
    }
    
    func searchLocation(query:String) {
        apiHandler.searchApi(location: query, completion: { [unowned self] (searchResults) in
            if let locations = searchResults {
                self.locations = locations
                self.reloadTableView?()
            }
        })
    }
}
