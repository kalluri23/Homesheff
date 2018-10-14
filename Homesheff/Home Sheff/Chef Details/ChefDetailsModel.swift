//
//  ChefDetailsModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/14/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
struct ChefServices {
    var name: String
    var serviceLocation: String
    var servicePrice: String
    var imageName: String
}

class ChefServiceModel {
  
    var chefService: [ChefServices]
    
    init() {
         chefService = [ChefServices(name: "Meal Prep", serviceLocation: "in your home", servicePrice: "$25.00", imageName: "mealprep-icon"),
        ChefServices(name: "Catering", serviceLocation: "Delivered to your home", servicePrice: "$25.00", imageName: "catering-icon"),
        ChefServices(name: "Grocery Shopping", serviceLocation: "Delivered to your home", servicePrice: "$25.00", imageName: "groceryshopping-icon")]
    }
}
