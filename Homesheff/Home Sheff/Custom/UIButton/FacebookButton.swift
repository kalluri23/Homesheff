//
//  FacebookButton.swift
//  Homesheff
//
//  Created by Krishna Theja Kalluri on 1/4/19.
//  Copyright © 2019 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class FacebookButton: UIControl  {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var logoText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    private func xibSetup() {
       Bundle.main.loadNibNamed("FacebookButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func showActivity() {
        logo.isHidden = true
        logoText.isHidden = true
        activityIndicator.startAnimating()
        isUserInteractionEnabled = false
    }
    
    func hideActivity() {
        logo.isHidden = false
        logoText.isHidden = false
        activityIndicator.stopAnimating()
        isUserInteractionEnabled = true
    }
    
    func setTitle(withText text: String) {
        logoText.text = text
    }

}
