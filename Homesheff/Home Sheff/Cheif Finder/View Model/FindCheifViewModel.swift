//
//  FindCheifViewModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 9/22/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MapKit

enum SearchType {
    case searchByName
    case searchByLocation
    case searchByServices
}

class FindCheifViewModel: NSObject {
    
    private let apiHandler = APIManager()
    
    var searchType: SearchType = .searchByName
    
    var reloadTableView: (() -> Void)?
    
    /// return default number of section
    var numberOfSections: Int {
        return 2
    }
    
    /// returns counts of cheif to generate the rows
    var numberOfRows: Int {
        
        switch searchType {
        case .searchByName,
        .searchByLocation, .searchByServices:
            return cheffServices.count
        }
    }
    
    func cheifObjectAtIndex(index: Int) -> Chef {
        return matchingCheffs[index]
    }
    
    func cheifServiceObjectAt(index: Int) -> ChefService {
        return cheffServices[index]
    }
    
    //TODO: cheif data should be dynamic
    
    var cheif = [Chef]()
    var cheffServices = [ChefService]()
    var matchingCheffs = [Chef]()
    override init() {
        super.init()
        decodeLocationAndGetSheffs(location: LocationManager.shared.currentLocation)
    }
    
    func getSheffsByLocation(requestEnvelope: Requestable, completion:@escaping (Bool) -> Void) {
        self.apiHandler.getSheffsByLocation(sheffRequestEnvelope: requestEnvelope) { (sheffList, status) in
            if sheffList != nil && sheffList?.count ?? 0 > 0 {
                self.cheffServices = sheffList!
                self.reloadTableView?()
                completion(true)
            } else {
               completion(false)
            }
        }
    }
    
    func getSheffsByLocation(location: String, completion:@escaping (Bool) -> Void) {
        let sheffRequestEnvelop = self.getSheffsByLocationEnvelop(location: location)
        self.getSheffsByLocation(requestEnvelope: sheffRequestEnvelop) { (status) in
            completion(status)
        }
    }
    
    func decodeLocationAndGetSheffs(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            self.searchType = .searchByLocation
            if(placemarks != nil) {
                let sheffRequestEnvelop = self.getSheffsByLocationEnvelop(location: "\(placemarks?.first?.locality ?? "Washington") \(placemarks?.first?.administrativeArea ?? "DC")")
                self.getSheffsByLocation(requestEnvelope: sheffRequestEnvelop) { (status) in
                    
                }
            }
        }
    }
    
    func getSheffsByLocationEnvelop(location: String) -> Requestable {
        
        let sheffListLocationPath = ServicePath.getSheffsByLocation(location: location)
        let sheffListEnvelop = GetSheffsByLocationEnvelop(pathType: sheffListLocationPath)
        return sheffListEnvelop
    }
    
    
    func searchCheffByName(searchText: String, location: String, completion: @escaping (Bool) -> Void) {
        
        apiHandler.searchServicesApi(requestEnvelop: self.searchCheffByNameEnvelop(searchString: searchText, location:location ), completion: {[unowned self] (list, isCompleted) in
            if isCompleted {
                if let cheffs = list {
                    self.cheffServices = cheffs
                    self.reloadTableView?()
                    completion(true)
                }
            } else {
                completion(false)
            }
        })
    }
    
    func searchServices(searchText: String, location: String, completion: @escaping (Bool) -> Void) {
        apiHandler.searchServicesApi(requestEnvelop: self.searchServicesEnvelop(searchString: searchText, location: location), completion: {[unowned self] (list, isCompleted) in
            if isCompleted {
                if let cheffs = list {
                   self.cheffServices = cheffs
                   self.reloadTableView?()
                    completion(true)
                }
            } else {
                 completion(false)
            }
        })
    }
    
    func getSheffById(envelop:Requestable, completion: @escaping (Chef?,Bool) -> Void) {
        apiHandler.getSheffById(requestEnvelop: envelop, completion: completion)
    }
    
    func getSheffByIdEnvelop(userId: Int) -> Requestable {
        let searchPath = ServicePath.getUserById(userId: userId)
        let userEnvelop = GetUserById(pathType: searchPath)
        return userEnvelop
    }

    
    func searchServicesEnvelop(searchString: String, location: String) -> Requestable {
        let searchServicesSearchPath = ServicePath.searchServices(searchString: searchString, location: location)
        let searchServicesEnvelop = SearchServices(pathType: searchServicesSearchPath)
        return searchServicesEnvelop
    }
    
    func searchCheffByNameEnvelop(searchString: String, location: String) -> Requestable {
        let searchCheffByNameSearchPath = ServicePath.searchCheffByName(searchString: searchString, location: location)
        let searchCheffByNameEnvelop = SearchCheffByName(pathType: searchCheffByNameSearchPath)
        return searchCheffByNameEnvelop
    }
}
