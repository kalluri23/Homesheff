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
        case .searchByName:
            return matchingCheffs.count
        case .searchByLocation, .searchByServices:
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
//        let sheffRequestEnvelop = self.getSheffsByLocationEnvelop(location: "Washington DC")
        decodeLocationAndGetSheffs(location: LocationManager.shared.currentLocation)
        
        // getListOfUser(userType: "all")
       //self.cheif = self.createArray()
    }
    
//    func getListOfUser(userType:String) {
//        apiHandler.fetchUserList(requestEnvelop: self.userListEnvelop()) { [weak self] (list,isCompleted ) in
//            self?.cheif = list!
//            self?.matchingCheffs = list!
//            self?.reloadTableView?()
//        }
//    }
    
    func getSheffsByLocation(requestEnvelope: Requestable) {
        self.apiHandler.getSheffsByLocation(sheffRequestEnvelope: requestEnvelope) { (sheffList, status) in
            if sheffList != nil && sheffList?.count ?? 0 > 0 {
                self.cheffServices = sheffList!
                self.reloadTableView?()
            }
        }
    }
    
    func getSheffsByLocation(location: String) {
        let sheffRequestEnvelop = self.getSheffsByLocationEnvelop(location: location)
        self.getSheffsByLocation(requestEnvelope: sheffRequestEnvelop)
    }
    
    func decodeLocationAndGetSheffs(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            self.searchType = .searchByLocation
            if(placemarks != nil) {
                let sheffRequestEnvelop = self.getSheffsByLocationEnvelop(location: "\(placemarks?.first?.locality ?? "Washington") \(placemarks?.first?.administrativeArea ?? "DC")")
                self.getSheffsByLocation(requestEnvelope: sheffRequestEnvelop)
            }
        }
    }
    
    func getSheffsByLocationEnvelop(location: String) -> Requestable {
        
        let sheffListLocationPath = ServicePath.getSheffsByLocation(location: location)
        let sheffListEnvelop = GetSheffsByLocationEnvelop(pathType: sheffListLocationPath)
        
        return sheffListEnvelop
    }
    
    
    func searchCheffByName(searchText: String, latitude: String, longitude: String) {
        
        apiHandler.searchServicesApi(requestEnvelop: self.searchCheffByNameEnvelop(searchString: searchText, latitude: latitude, longitude: longitude), completion: {[unowned self] (list, isCompleted) in
            if isCompleted {
                if let cheffs = list {
                    self.cheffServices = cheffs
                    self.reloadTableView?()
                }
            }else {
                
            }
        })
    }
    
    func searchServices(searchText: String, latitude: String, longitude: String) {
        apiHandler.searchServicesApi(requestEnvelop: self.searchServicesEnvelop(searchString: searchText, latitude: latitude, longitude: longitude), completion: {[unowned self] (list, isCompleted) in
            if isCompleted {
                if let cheffs = list {
                   self.cheffServices = cheffs
                   self.reloadTableView?()
                }
            }else {
                
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
    
//
//    func userListEnvelop() -> Requestable {
//
//        let userListSearchPath = ServicePath.listOfUsers(userType: "all")
//        let userListEnvelop = ListOfUsers(pathType: userListSearchPath)
//
//        return userListEnvelop
//    }
    
   
    
    
    func searchServicesEnvelop(searchString: String, latitude: String, longitude: String) -> Requestable {
        let searchServicesSearchPath = ServicePath.searchServices(searchString: searchString, lat: latitude, lon: longitude)
        let searchServicesEnvelop = SearchServices(pathType: searchServicesSearchPath)
        return searchServicesEnvelop
    }
    
    func searchCheffByNameEnvelop(searchString: String, latitude: String, longitude: String) -> Requestable {
        let searchCheffByNameSearchPath = ServicePath.searchCheffByName(searchString: searchString, lat: latitude, lon: longitude)
        let searchCheffByNameEnvelop = SearchServices(pathType: searchCheffByNameSearchPath)
        return searchCheffByNameEnvelop
    }
 
    /**This function will search user by firstname from master list and put in matching cheffs
    */
    func searchListOfUser(matchingString:String? = nil) {
        guard let searchText = matchingString else {
            self.matchingCheffs = self.cheif
            self.reloadTableView?()
            return
        }
        let matchingChefs = self.cheif.filter({(cheff) in
            if let firstName = cheff.firstName {
                if let _ = firstName.range(of: searchText, options: .caseInsensitive) {
                    return true
                } else {
                    return false
                }
            }else {
                return false
            }
        })
        self.matchingCheffs = matchingChefs
        self.reloadTableView?()
    }
    
}
