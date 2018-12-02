//
//  HSTextField.swift
//  Homesheff
//
//  Created by bkongara on 12/2/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

@IBDesignable class HSTextField: UITextField {
    
    @IBInspectable var leftPadding: CGFloat = 10
    @IBInspectable var color:UIColor = UIColor.lightGray{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var customRightView: UIView? {
        
        didSet{
            updateView()
        }
    }
    
    func setUpViews() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShowOrHideButton()
    }
    
    func addShowOrHideButton() {
        rightViewMode = UITextFieldViewMode.always
        let rtInnerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 15))
        button.setTitle("SHOW", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(rightButtonClicked(_sender:)), for: .touchUpInside)
        rtInnerView.addSubview(button)
        rtInnerView.tintColor = color
        rightView = rtInnerView
        
    }
    
    @objc func rightButtonClicked(_sender: Any) {
        
        let button =  _sender as! UIButton
        if (button.titleLabel?.text == "SHOW") {
            button .setTitle("HIDE", for: .normal)
             self.isSecureTextEntry = false
        } else {
            button .setTitle("SHOW", for: .normal)
            self.isSecureTextEntry = true
        }
    }
    
    
    func updateView() {
        
        if let rtView = customRightView{
            rightViewMode = UITextFieldViewMode.whileEditing
            let rtInnerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            rtInnerView.addSubview(rtView)
            rtInnerView.tintColor = color
            rightView = rtView
        }
        else{
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
    }


}
