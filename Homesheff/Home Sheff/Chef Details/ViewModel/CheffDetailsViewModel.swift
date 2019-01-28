//
//  ChefDetailsModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

enum ProfileTableViewCellType {
    case headerType
    case photoGalleryType
    case aboutType
    case servicesType
}

class CheffDetailsViewModel: NSObject {
  
    var chefServices: [SheffService]?
    var chefInfo: Chef?
    private let apiHandler = APIManager()
    
    var reloadTableView: (() -> Void)?
    
    var prepareSections:[ProfileTableViewCellType] {
        return [.headerType, .photoGalleryType, .servicesType, .aboutType]
    }
    
    /// returns counts of cheif to generate the rows
    func numberOfRows(sectionType: ProfileTableViewCellType) -> Int {
        switch sectionType {
            case .aboutType, .photoGalleryType, .headerType:
                return 1
            case .servicesType:
                guard let services = chefServices else {
                    return 1
                }
                return services.count
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
