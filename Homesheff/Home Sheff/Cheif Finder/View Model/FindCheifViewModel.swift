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
    
    private let apiHandler = APIManager()


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
        apiHandler.fetchUserList(requestEnvelop: self.userListEnvelop()) { [weak self] (list,isCompleted ) in
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
    
    func downloadImage(imageName:String, completion: @escaping (UIImage) -> ()) {
        if let image = apiHandler.cachedImage(for: imageName) {
            completion(image)
            return
        }
        apiHandler.retrieveImage(for: imageName) { (image) in
            if let image = image {
                completion(image)
            }
        }
    }
    
    func prepareProfileImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true;
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
    }
 
    /**This function will search user by firstname from master list and put in matching cheffs
    */
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
    @IBAction func textDidChange(_ sender: UITextField, forEvent event: UIEvent) {
        if let searchText = sender.text, !searchText.isEmpty{
            print(searchText)
            searchListOfUser(matchingString: searchText)
        }else {
            self.matchingCheffs = self.cheif
        }
        self.reloadTableView?()
    }
    
}
