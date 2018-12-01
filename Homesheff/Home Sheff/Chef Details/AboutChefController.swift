//
//  AboutChefController.swift
//  Homesheff
//
//  Created by bkongara on 12/1/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class AboutChefController: UIViewController {
    
    @IBOutlet weak var aboutLbl: UILabel!
    var aboutChefTxt: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (aboutChefTxt != nil) {
            aboutLbl.text = aboutChefTxt
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        self.navigationItem.title = "About"
        self.navigationController?.isNavigationBarHidden = false
         // self.navigationController.
    }
    
    static func create(aboutChef: String) -> AboutChefController {
       let aboutStoryBoard = UIStoryboard.init(name: "ChefDetails", bundle: nil)
       let aboutChefVC =  aboutStoryBoard.instantiateViewController(withIdentifier: "AboutChefController") as! AboutChefController
       aboutChefVC.aboutChefTxt = aboutChef
       return aboutChefVC
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
