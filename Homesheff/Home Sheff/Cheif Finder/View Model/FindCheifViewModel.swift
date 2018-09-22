//
//  FindCheifViewModel.swift
//  Homesheff
//
//  Created by Anurag Yadev on 9/22/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class FindCheifViewModel: NSObject {
    
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
       self.cheif = self.createArray()
    }
    
 
    
/// Temp data to feed UI
///
/// - Returns: return array of chef
private func createArray() -> [Chef]{
    
    var tempChefs: [Chef] = []
    
    let chef1 = Chef(chefImage: #imageLiteral(resourceName: "soma-kun"), chefName: "Ray", chefLocation: "Virginia, USA", chefRate: "25.00")
    let chef2 = Chef(chefImage: #imageLiteral(resourceName: "erina-sama"), chefName: "Erina", chefLocation: "Kyoto, Japan", chefRate: "35.00")
    let chef3 = Chef(chefImage: #imageLiteral(resourceName: "alice-nakiri"), chefName: "Alice", chefLocation: "Akina, Japan", chefRate: "40.00")
    let chef4 = Chef(chefImage: #imageLiteral(resourceName: "aldini-takumi"), chefName: "Takumi", chefLocation: "Osaka, Japan", chefRate: "29.00")
    
    tempChefs.append(chef1)
    tempChefs.append(chef2)
    tempChefs.append(chef3)
    tempChefs.append(chef4)
    
    return tempChefs
   }
}
