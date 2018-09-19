//
//  LocationServicesRatesViewController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/18/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class LocationServicesRatesViewController: UIViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var locationTextView: UITextView!
    
    var location: String?
    var services: String?
    var rates: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 20
        if let location = location {
            
            locationTextView.text = location
        }
        
        locationTextView.becomeFirstResponder()
        
        navigationController?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if let formViewController = viewController as? FinishYourProfile {
            
            formViewController.location = locationTextView.text
        }
    }
}
