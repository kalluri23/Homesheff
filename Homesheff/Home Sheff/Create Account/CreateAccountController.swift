//
//  CreateYourAccountController.swift
//  Homesheff
//
//  Created by Dimitrios Papageorgiou on 9/12/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


extension UITextField{
    
    func setBottomBorderLightGray(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class CreateAccountController: UIViewController {
    
    @IBOutlet weak var createAccountTableView: UITableView!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    private let unSelectedCheckboxImage = UIImage(named: "checkbox-blank")
    private let selectedCheckboxImage = UIImage(named: "checkbox-selected")
    
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var phoneNo: String?
    var isChef = false
    var isCustomer = false
    var imageUrl = "https://png.icons8.com/color/2x/person-male.png"
    var zipCode = "20017"
    
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!

    
    private let viewModel = CreateAccountViewModel()
    private let signInViewModel = SignInViewModel()
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @objc func checkBoxTapped(_ sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(unSelectedCheckboxImage, for: .normal)
        }
        else {
            sender.isSelected = true
            sender.setImage(selectedCheckboxImage, for: .normal)
        }
        
        if sender.tag == 1 {
            isChef = sender.isSelected
        } else {
            isCustomer = sender.isSelected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadingIndicator.color = .black
        loadingIndicator.type = .ballClipRotate
        setTermsAndConditions()
    
        // Register cell
        
        createAccountTableView.register(GenericFieldsCellTableViewCell.nib, forCellReuseIdentifier: GenericFieldsCellTableViewCell.reuseIdentifier)
        createAccountTableView.register(ChefFieldsCell.nib, forCellReuseIdentifier: ChefFieldsCell.reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async( execute: {
            var frame = self.createAccountTableView.frame
            frame.size.height = self.createAccountTableView.contentSize.height
            self.createAccountTableView.frame = frame
        })
    }
    
    @IBAction func callSignupAPI() {
       
        self.view.endEditing(true) // Force end editing to get the last generic field user entry
        let item = viewModel.fields[0]
        if item.type == .genericField {
              if let item = item as? GenericFieldItem {
                for value in item.genericData {
                    switch value.placeHolder {
                    case "Email":
                        email = value.name
                    case "Password":
                        password = value.name
                    case "First Name":
                        firstName = value.name
                    case "Phone No":
                        phoneNo = value.name
                    case "Last Name":
                        lastName = value.name
                    default:
                        print(value.name)
                    }
                }
            }
        }
        
        signupAPI()
    }
    
    private func signupAPI() {
        
        if isTextFieldHasText() {
            loadingIndicator.startAnimating()
            
            viewModel.signUp(envelop: signUpEnvelop()) { [weak self] isSuccess in
                
                if isSuccess{
                    // Login again
                    // TODO: Make common Signin api call
                    self?.callLoginAPI()
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.showAlert(title: "Oops!", message: "Please check your details")
                }
                
            }
        } else {
            self.showAlert(title: "Oops!", message: "Please check your details")
        }
    }
    
    private func isTextFieldHasText() -> Bool {
        if email?.isEmpty ?? false || password?.isEmpty ?? false || phoneNo?.isEmpty ?? false || (isChef == false && isCustomer == false) {
            return false
        }
        return true
    }
    
    private func navigateToFinishYourProfile() {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "finishProfileID")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func navigateToBaseTabBar() {
        let baseTabbar = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
        self.present(baseTabbar, animated: true, completion: nil)
    }
    
   private func signUpEnvelop() -> Requestable {
        
    let signupSearchPath = ServicePath.signUpCall(email: email!, password: password!, phoneNo: phoneNo, firstName: firstName!, lastName: lastName!, isChef: isChef, isCustomer: isCustomer, imageUrl: imageUrl, zipCode: zipCode)
        let signupEnvelop = SaveUserPreferencesEnvelop(pathType: signupSearchPath)
        
        return signupEnvelop
    }
    
    private func callLoginAPI() {
        if isTextFieldHasText() {
            loadingIndicator.startAnimating()
            signInViewModel.signInApi(envelop:signInViewModel.signInEnvelop(userName: email!, password: password!)) { [weak self] isSuccess in
                
                if isSuccess{
                    
                    //TODO: Manage session time out from API --later
                    UserDefaults.standard.set(true, forKey: "userLoggedIn")
                    
                    if let isCustomer = self?.isCustomer, isCustomer {
                        self?.navigateToBaseTabBar()
                    } else {
                        self?.navigateToFinishYourProfile()
                    }
                    
                } else {
                    self?.showAlert(title: "Oops!", message: "Please check your email address & password")
                }
                self?.loadingIndicator.stopAnimating()
            }
        } else {
            self.showAlert(title: "Oops!", message: "Please check your email address & password")
        }
    }
}

extension CreateAccountController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fields[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.fields[indexPath.section]
        
        switch item.type {
        case .genericField:
            
            if let item = item as? GenericFieldItem {
                let cell: GenericFieldsCellTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.geneircFields = item.genericData[indexPath.row]
                cell.genericField.tag = indexPath.item
                cell.tag = indexPath.section
                cell.genericField.delegate = self
                return cell
            }
            
        case .categoryField:
            
            if let item = item as? CategoryFieldItem {
                let cell: ChefFieldsCell = tableView.dequeueReusableCell(for: indexPath)
                cell.category = item.categoryFieldData[indexPath.row]
                cell.checkCategory.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
                cell.checkCategory.tag = indexPath.row
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension CreateAccountController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            if let headerView = tableView.dequeueReusableCell(withIdentifier: "SelectOptionHeaderCell") {
                return headerView;
            }
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 44 : 0
    }
}

//TODO: Move it cell class
extension CreateAccountController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if viewModel.fields[0].type == .genericField {
            
            if let item = viewModel.fields[0] as? GenericFieldItem {
                item.genericData[textField.tag].name = textField.text ?? ""
                
                print(item.genericData[textField.tag].name)
            }
        }
    }
}

extension CreateAccountController {
    
    func setTermsAndConditions() {
        
        let termsAndConditionsText = "By signing up, I agree to the Terms of Service and Privacy Statement, and consent to receiving email communication."
        termsAndConditionsLabel.text = termsAndConditionsText
        
        let termsOfServiceString = "Terms of Service"
        let termsOfServiceRange = (termsAndConditionsText as NSString).range(of: termsOfServiceString)
        let attribute = NSMutableAttributedString.init(string: termsAndConditionsText)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.appDefaultColor , range: termsOfServiceRange)
        
        let privacyStatement = "Privacy Statement"
        let privacyStatementRange = (termsAndConditionsText as NSString).range(of: privacyStatement)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.appDefaultColor , range: privacyStatementRange)
        termsAndConditionsLabel.attributedText = attribute
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        termsAndConditionsLabel.addGestureRecognizer(tap)
        termsAndConditionsLabel.isUserInteractionEnabled = true
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (termsAndConditionsLabel.text)!
        let termsRange = (text as NSString).range(of: " Terms of Service")
        let privacyRange = (text as NSString).range(of: " Privacy Statement")
        
        if gesture.didTapAttributedTextInLabel(label: termsAndConditionsLabel, inRange: privacyRange) {
            didTapTermsAndCondition(isTermsAndCondition: false)
        } else if gesture.didTapAttributedTextInLabel(label: termsAndConditionsLabel, inRange: termsRange) {
           didTapTermsAndCondition(isTermsAndCondition: true)
        }
    }
    
    private func didTapTermsAndCondition(isTermsAndCondition: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionViewControllerID") as! TermsAndConditionViewController
        vc.isTermsAndCondition = isTermsAndCondition
        self.present(vc, animated: true, completion: nil)
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x + textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
