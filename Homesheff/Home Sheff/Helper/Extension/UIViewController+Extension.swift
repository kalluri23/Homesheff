//
//  UIViewController+Extension.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 12/31/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertWith(alertTitle title:String, alertBody body:String? = nil, action: (()->(Void))? = nil, completion: (()->(Void))? = nil) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            action?()
        }))
        self.present(alert, animated: true, completion: {
            completion?()
        })
        
    }
}
