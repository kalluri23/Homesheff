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

class ChefServiceModel {
  
    var chefService: [ChefServices]
    let apiHandler = APIManager()
    init() {
         chefService = [ChefServices(name: "Meal Prep", serviceLocation: "in your home", servicePrice: "", imageName: "mealprep-icon"),
        ChefServices(name: "Catering", serviceLocation: "Delivered to your home", servicePrice: "", imageName: "catering-icon"),
        ChefServices(name: "Grocery Shopping", serviceLocation: "Delivered to your home", servicePrice: "", imageName: "groceryshopping-icon")]
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
}
