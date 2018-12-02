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
    var numberOfSection: Int {
        return 1
    }
    
    /// returns counts of cheif to generate the rows
    var numberOfRows: Int {
        return cheif.count
    }
    
    //TODO:  Should return optional in future, because data will come from server and we were not sure that we always have value for chef or not
    
    
    /// Feed cell of tableview
    ///
    /// - Parameter index: index of cell
    /// - Returns: cheif object to feed tableview cell
    func cheifObjectAtIndex(index: Int) -> Chef {
        
        return cheif[index]
    }
    
    //TODO: cheif data should be dynamic
    
    var cheif = [Chef]()
    override init() {
        super.init()
        
        getListOfUser(userType: "all")
       //self.cheif = self.createArray()
    }
    
    private func getListOfUser(userType:String) {
        apiHandler.fetchUserList(requestEnvelop: self.userListEnvelop()) { [weak self] (list,isCompleted ) in
            self?.cheif = list!
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
 
    
/// Temp data to feed UI
///
/// - Returns: return array of chef
//private func createArray() -> [Chef]{
//    
//    var tempChefs: [Chef] = []
//    
////    let chef1 = Chef(chefImage: #imageLiteral(resourceName: "soma-kun"), chefName: "Ray", chefLocation: "Virginia, USA", chefRate: "25.00")
////    let chef2 = Chef(chefImage: #imageLiteral(resourceName: "erina-sama"), chefName: "Erina", chefLocation: "Kyoto, Japan", chefRate: "35.00")
////    let chef3 = Chef(chefImage: #imageLiteral(resourceName: "alice-nakiri"), chefName: "Alice", chefLocation: "Akina, Japan", chefRate: "40.00")
////    let chef4 = Chef(chefImage: #imageLiteral(resourceName: "aldini-takumi"), chefName: "Takumi", chefLocation: "Osaka, Japan", chefRate: "29.00")
//    
//    tempChefs.append(chef1)
//    tempChefs.append(chef2)
//    tempChefs.append(chef3)
//    tempChefs.append(chef4)
//    
//    return tempChefs
//   }
}
