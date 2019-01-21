//
//  FindCheifViewModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 9/22/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum SearchType {
    case searchByFirstName
    case searchByLocation
}

class FindCheifViewModel: NSObject {
    
    private let apiHandler = APIManager()
    
    var searchType: SearchType = .searchByFirstName
    
    var reloadTableView: (() -> Void)?
    
    /// return default number of section
    var numberOfSections: Int {
        return 2
    }
    
    /// returns counts of cheif to generate the rows
    var numberOfRows: Int {
        
        switch searchType {
        case .searchByFirstName:
            return matchingCheffs.count
        case .searchByLocation:
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
        
        getListOfUser(userType: "all")
       //self.cheif = self.createArray()
    }
    
    func getListOfUser(userType:String) {
        apiHandler.fetchUserList(requestEnvelop: self.userListEnvelop()) { [weak self] (list,isCompleted ) in
            self?.cheif = list!
            self?.matchingCheffs = list!
            self?.reloadTableView?()
        }
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
    
    func userListEnvelop() -> Requestable {
        
        let userListSearchPath = ServicePath.listOfUsers(userType: "all")
        let userListEnvelop = ListOfUsers(pathType: userListSearchPath)
        
        return userListEnvelop
    }
    
    func searchServicesEnvelop(searchString: String, latitude: String, longitude: String) -> Requestable {
        let searchServicesSearchPath = ServicePath.searchServices(searchString: searchString, lat: latitude, lon: longitude)
        let searchServicesEnvelop = SearchServices(pathType: searchServicesSearchPath)
        return searchServicesEnvelop
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
