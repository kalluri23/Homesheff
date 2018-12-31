//
//  APIEndPoints.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation


protocol ParameterBodyMaker {
  func httpBodyEnvelop()->[String:Any]?
  func encodeBodyEnvelop() throws -> Data?
}

/*
 Request Envelops are mentioned here with api path, pathType(Enum with tupple which holds api parameters)
 */
struct ListOfUsers:Requestable {
  var apiPath:String { return "getListOfUsers/chef" }
  var httpType:HttpType { return .get }
  var pathType : ServicePath
}

struct SignInEnvelop:Requestable {
    var apiPath:String { return "getUserByUsernamePassword" }
    var httpType:HttpType { return .get }
    var pathType : ServicePath
}

struct SignUpEnvelop:Requestable {
    var apiPath:String { return "saveUserInformation" }
    var httpType:HttpType { return .post }
    var pathType : ServicePath
}

struct SaveUserPreferencesEnvelop:Requestable {
    var apiPath:String { return "saveUserPreferences" }
    var httpType:HttpType { return .post }
    var pathType : ServicePath
}

struct UpdateUserPreferencesEnvelop:Requestable {
    var apiPath:String 
    var httpType:HttpType { return .put }
    var pathType : ServicePath
}

struct GetPhotoGallery: Requestable {
    var apiPath: String { return "getAllPhotoGallery" }
    var httpType: HttpType { return .get}
    var pathType: ServicePath
}

struct SavePhotoToGallery: Requestable {
    var apiPath: String { return "savePhotoToGallery" }
    var httpType: HttpType { return .post}
    var pathType: ServicePath
}

struct DeletePhotoFromGallery: Requestable {
    var apiPath: String { return "deletePhotoFromGallery" }
    var httpType: HttpType { return .delete}
    var pathType: ServicePath
}

/*
 ALL services post dictionary is mentioned under enum switch statement.
 These cases get their values in ViewController (or respective controller or other class).
 This enum also wrap a method which provides dictionary for post body.
 */
internal enum ServicePath:ParameterBodyMaker {
    
    case listOfUsers(userType: String)
    case signInCall(userName: String, password: String)
    case signUpCall(email: String, password: String, phoneNo: String?, firstName: String, lastName: String, isChef: Bool, isCustomer: Bool, imageUrl: String, zipCode: String)
    case updateUserPreferenceCall(firstName: String?, lastName: String?, headline: String?, phoneNo: String?, location: String?, zipCode: String?, services: String?, isChef: Bool?, isCustomer: Bool?)
    
    func httpBodyEnvelop()->[String:Any]? {
        
        switch self {
        case .listOfUsers(userType: let userType):
            
            return ["userType": userType]
            
        case .signInCall(userName: let userName, password: let password):
            return ["username": userName, "password": password]
            
        case .signUpCall(email: let email, password: let password, phoneNo: let phoneNo, firstName: let firstName, lastName: let lastName, isChef: let isChef, isCustomer: let isCustomer, imageUrl: let imageUrl, zipCode: let zipCode):
            return ["email": email, "password": password, "phone": phoneNo ?? "", "firstName": firstName, "lastName": lastName, "isChef": isChef, "isCustomer": isCustomer, "imageUrl": imageUrl, zipCode: "zipCode"]
            
        case .updateUserPreferenceCall(let firstName, let lastName, let headline, let phoneNo, let location, let zipCode, let services, let isChef, let isCustomer):
            return ["firstName": firstName ?? "", "lastName": lastName ?? "" , "phone": phoneNo ?? "" , "headertext": headline ?? "", "phoneNo": phoneNo ?? "", "location": location ?? "", "zipCode": zipCode ?? "", "services": services ?? "", "isChef": isChef ?? "", "isCustomer": isCustomer ?? ""]
            
        }
    }
    
    func encodeBodyEnvelop() throws -> Data? {
        
        do {
            if let body = self.httpBodyEnvelop() {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                return data
            }
        }
        catch  {
            throw error
        }
        
        return nil
    }
}
