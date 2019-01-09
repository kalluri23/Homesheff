//
//  ChefDetailsModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

struct ChefServices {
    var name: String
    var serviceLocation: String
    var servicePrice: String
    var imageName: String
}

enum ProfileTableViewCellType {
    case headerType
    case photoGalleryType
    case aboutType
    case servicesType
}

class ProfileViewModel {
  
    var chefService: [ChefServices]
    var chefInfo: Chef?
    private let apiHandler = APIManager()
    
    var reloadTableView: (() -> Void)?
    
    init() {
        chefService = [ChefServices(name: "Meal Prep", serviceLocation: "in your home", servicePrice: "", imageName: "mealprep-icon"),
                       ChefServices(name: "Catering", serviceLocation: "Delivered to your home", servicePrice: "", imageName: "catering-icon"),
                       ChefServices(name: "Grocery Shopping", serviceLocation: "Delivered to your home", servicePrice: "", imageName: "groceryshopping-icon")]
    }
    
    var prepareSections:[ProfileTableViewCellType] {
        if chefInfo?.about != nil && chefInfo?.photoGallery != nil && (chefInfo?.photoGallery!.count)! > 0 {
            return [.headerType, .photoGalleryType,  .servicesType, .aboutType]
        } else if (chefInfo?.about != nil) {
            return [.headerType, .photoGalleryType, .servicesType, .aboutType]
        } else {
            return [.headerType, .servicesType]
        }
    }
    
    /// returns counts of cheif to generate the rows
    func numberOfRows(sectionType: ProfileTableViewCellType) -> Int {
        switch sectionType {
            case .aboutType, .photoGalleryType, .headerType:
                return 1
            case .servicesType:
                return chefService.count
        }
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
    
    func getPhotosToGalleryEnvelop(userId: Int) -> Requestable {
        let searchPath = ServicePath.getPhotoGallery(userId: userId)
        let photoGalleryEnvelop = GetPhotoGallery(pathType: searchPath)
        return photoGalleryEnvelop
    }

    func getPhotosToGallery(envelop:Requestable, completion: @escaping ([PhotoData]?) -> Void) {
        apiHandler.getPhotoGallery(requestEnvelop: envelop, completion: completion)
    }
    
}
