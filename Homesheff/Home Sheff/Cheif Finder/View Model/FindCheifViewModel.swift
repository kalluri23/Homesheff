//
//  FindCheifViewModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 9/22/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FindCheifViewModel: NSObject {
    
    private let getUserList = APIManager()

    var reloadTableView: (() -> Void)?
    
    /// return default number of section
    var numberOfSections: Int {
        return 2
    }
    
    /// returns counts of cheif to generate the rows
    var numberOfRows: Int {
        return matchingCheffs.count
    }
    
    //TODO:  Should return optional in future, because data will come from server and we were not sure that we always have value for chef or not
    
    
    /// Feed cell of tableview
    ///
    /// - Parameter index: index of cell
    /// - Returns: cheif object to feed tableview cell
    func cheifObjectAtIndex(index: Int) -> Chef {
        
        return matchingCheffs[index]
    }
    
    //TODO: cheif data should be dynamic
    
    var cheif = [Chef]()
    var matchingCheffs = [Chef]()
    override init() {
        super.init()
        
        getListOfUser(userType: "all")
       //self.cheif = self.createArray()
    }
    
    private func getListOfUser(userType:String) {
        getUserList.fetchUserList(requestEnvelop: self.userListEnvelop()) { [weak self] (list,isCompleted ) in
            self?.cheif = list!
            self?.matchingCheffs = list!
            self?.reloadTableView?()
        }
    }
    
    func userListEnvelop() -> Requestable {
        
        let userListSearchPath = ServicePath.listOfUsers(userType: "all")
        let userListEnvelop = ListOfUsers(pathType: userListSearchPath)
        
        return userListEnvelop
    }
    
    func searchListOfUser(matchingString:String) {
        let matchingChefs = self.cheif.filter({(cheff) in
            if let firstName = cheff.firstName {
                if let _ = firstName.range(of: matchingString, options: .caseInsensitive) {
                    return true
                } else {
                    return false
                }
            }else {
                return false
            }
        })
        self.matchingCheffs = matchingChefs
    }
}

extension FindCheifViewModel: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let searchText = textField.text {
            print(searchText)
            searchListOfUser(matchingString: searchText)
            self.reloadTableView?()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            print(searchText)
            searchListOfUser(matchingString: searchText)
            self.reloadTableView?()
        }
        return true
    }
    
}
