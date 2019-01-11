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
    
    //MARK: - IBOutlets
    @IBOutlet weak var createAccountTableView: UITableView!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    @IBOutlet weak var signUpButton: SpinningButton!
    @IBOutlet weak var signInViewModel: SignInViewModel!
    @IBOutlet weak var createAccountViewModel: CreateAccountViewModel!
    
    //MARK: - Private properties
    private let unSelectedCheckboxImage = UIImage(named: "checkbox-blank")
    private let selectedCheckboxImage = UIImage(named: "checkbox-selected")
    
    //MARK: - Basic Details
    var basicDetails: Details!
    
    //MARK: - Facebook Properties
    var isFaceBookSignUp = false
    
    //MARK: - Selectors
    @objc func checkBoxTapped(_ sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(unSelectedCheckboxImage, for: .normal)
        }else {
            sender.isSelected = true
            sender.setImage(selectedCheckboxImage, for: .normal)
        }
        if sender.tag == 1 {
            basicDetails.isChef = sender.isSelected
        } else {
            basicDetails.isCustomer = sender.isSelected
        }
        self.signUpButton.isEnabled(validateFields())
    }
    
    //MARK: - Life Cycle Methods
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
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if isFaceBookSignUp{
            prePopulate(email: basicDetails.email, firstName: basicDetails.firstName, lastName: basicDetails.lastName)
        }
        self.signUpButton.isEnabled(false)
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
    
    deinit {
        print("Create Account VC deinit called")
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "FinishYourProfileSegue", let profileImage = sender as? UIImage {
            let finishProfileVC = segue.destination as! FinishYourProfileController
            finishProfileVC.profilePicImage = profileImage
        }
    }
    
    //MARK: - IBActions
    @IBAction func signUpButtonTapped() {
        self.callSignupAPI()
    }
    
    //MARK: - Helper Functions
    private func prePopulate(email:String, firstName:String, lastName:String) {
        if let fieldItems = createAccountViewModel.fields[0] as? GenericFieldItem {
            for (index, itemData) in fieldItems.genericData.enumerated() {
                switch itemData.placeHolder {
                case "Email":
                    fieldItems.genericData[index].name = email
                case "First Name":
                    fieldItems.genericData[index].name = firstName
                case "Last Name":
                    fieldItems.genericData[index].name = lastName
                default:
                    fieldItems.genericData[index].name = ""
                }
            }
        }
        self.createAccountTableView.reloadData()
    }
    
    /** Enumerate through view model data to find if all the fields are valid
    */
    private func validateFields() -> Bool {
        var isValidField = true
        if let fieldItems = createAccountViewModel.fields[0] as? GenericFieldItem {
            for (index, itemData) in fieldItems.genericData.enumerated() {
                switch itemData.placeHolder {
                case "Email":
                    isValidField = fieldItems.genericData[index].name.isValidEmail() && isValidField
                case "First Name":
                    isValidField = !fieldItems.genericData[index].name.isEmpty && isValidField
                case "Last Name":
                    isValidField = !fieldItems.genericData[index].name.isEmpty && isValidField
                case "Password":
                    isValidField = fieldItems.genericData[index].name.isValidPassword() && isValidField
                default:
                    break
                }
            }
        }
        
        return isValidField && (basicDetails.isChef || basicDetails.isCustomer)
    }
    
    private func update(textField: UITextField) {
        if let item = createAccountViewModel.fields[0] as? GenericFieldItem, let text = textField.text {
            item.genericData[textField.tag].name = text
            switch item.genericData[textField.tag].placeHolder {
            case "Email":
                basicDetails.email = text
            case "Password":
                basicDetails.password = text
            case "First Name":
                basicDetails.firstName = text
            case "Last Name":
                basicDetails.lastName = text
            default:
                print(text)
            }
        }
        self.signUpButton.isEnabled(validateFields())
    }
    
    private func showNextScreen(profileImage: UIImage? = nil) {
        if self.basicDetails.isCustomer { //Show home screen
            let baseTabbar = self.storyboard?.instantiateViewController(withIdentifier:"MainTabBarControllerId") as! BaseTabbarController
            self.present(baseTabbar, animated: true, completion: nil)
        } else if self.basicDetails.isChef { // Show finish cheff profile screen
            self.performSegue(withIdentifier: "FinishYourProfileSegue", sender: profileImage)
        }
    }
    
    //MARK: - API Methods
    private func callSignupAPI() {
        loadingIndicator.startAnimating()
        createAccountViewModel.signUp(envelop: createAccountViewModel.signUpEnvelop(basicDetails: basicDetails)) { [unowned self] isSuccess in
            if isSuccess{
                self.callLoginAPI()
            } else {
                self.loadingIndicator.stopAnimating()
                self.showAlert(title: "Oops!", message: "Please check your details")
            }
            
        }
    }
    
    private func callLoginAPI() {
        loadingIndicator.startAnimating()
        signInViewModel.signInApi(envelop:signInViewModel.signInEnvelop(userName: basicDetails.email, password: basicDetails.password)) { [unowned self] isSuccess in
            self.loadingIndicator.stopAnimating()
            if isSuccess{
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                self.createAccountViewModel.apiHandler.downLoadFBProfileImage(from: self.basicDetails.imageUrl, completion: { [unowned self] image in
                    if let fbProfileImage = image {
                        self.createAccountViewModel.apiHandler.uploadPhoto(fbProfileImage, fileName: "\(User.defaultUser.currentUser!.id!)_ProfilePhoto", completionHandler: { [unowned self] isSuccess in
                            if isSuccess {
                                self.showNextScreen(profileImage: fbProfileImage)
                            }else {
                                self.showAlertWith(alertTitle: "Warning", alertBody: "Unable to set profile picture at this time. Please set your photo manually in settings.", action: { [unowned self] in
                                    self.showNextScreen()
                                })
                            }
                        })
                    }else {
                        self.showNextScreen()
                    }
                })
                
            } else {
                self.showAlert(title: "Oops!", message: "Please check your email address & password")
            }
        }
    }
}

//MARK: - TableView Data Source Delegate
extension CreateAccountController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return createAccountViewModel.fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createAccountViewModel.fields[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = createAccountViewModel.fields[indexPath.section]
        
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

//MARK: - TableView Delegate
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

//MARK: - TextField Delegate
extension CreateAccountController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        update(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        update(textField: textField)
        textField.resignFirstResponder()
        return true
    }
    
    /* //FIXME: - Handle this delegate to improve experience
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     update(textField: textField)
     return true
     }
     */
}

//MARK: - Attributed Text Configuration functions
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
