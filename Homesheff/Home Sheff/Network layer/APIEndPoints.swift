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

struct ForgotPasswordEnvelop:Requestable {
    var apiPath:String { return "forgotPassword/" + pathType.serviceEndpoint() }
    var httpType:HttpType { return .get }
    var pathType : ServicePath
}

struct ValidateCodeEnvelop:Requestable {
    var apiPath:String { return "validateCode/" + pathType.serviceEndpoint() }
    var httpType:HttpType { return .get }
    var pathType : ServicePath
}

struct ResetPasswordEnvelop:Requestable {
    var apiPath:String { return "resetPassword" }
    var httpType:HttpType { return .post }
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
    var apiPath: String { return  "getAllPhotoGallery/" + pathType.serviceEndpoint()}
    var httpType: HttpType { return .get }
    var pathType: ServicePath
}

struct SavePhotoToGallery: Requestable {
    var apiPath: String { return "savePhotoToGallery" }
    var httpType: HttpType { return .post}
    var pathType: ServicePath
}

struct DeletePhotoFromGallery: Requestable {
    var apiPath: String { return "deletePhotoFromGallery/" + pathType.serviceEndpoint() }
    var httpType: HttpType { return .delete}
    var pathType: ServicePath
}
struct GetUserById: Requestable {
    var apiPath: String { return "getUserById/" + pathType.serviceEndpoint() }
    var httpType: HttpType { return .get }
    var pathType: ServicePath
}

struct SearchServices: Requestable {
    var apiPath: String { return "searchServices/" + pathType.serviceEndpoint() }
    var httpType: HttpType { return .get }
    var pathType: ServicePath
}

struct GetServicesEnvelop:Requestable {
    var apiPath:String { return "getServices/" + pathType.serviceEndpoint() }
    var httpType:HttpType { return .get }
    var pathType : ServicePath
}

struct AddServiceEnvelop: Requestable {
    var apiPath:String { return "addService" }
    var httpType:HttpType { return .post }
    var pathType : ServicePath
}

struct EditServiceEnvelop: Requestable {
    var apiPath:String { return "editService/" + pathType.serviceEndpoint()  }
    var httpType:HttpType { return .put }
    var pathType : ServicePath
}

struct DeleteServiceEnvelop: Requestable {
    var apiPath: String { return "deleteService/" + pathType.serviceEndpoint() }
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
    case forgotPassword(email: String)
    case resetPassword(email:String, code:String, password:String)
    case getUserById(userId: Int)
    case getPhotoGallery(userId: Int)
    case deletePhotoFromGallery(photoId: Int)
    case validate(email:String, code:String)
    case updateUserPreferenceCall(firstName: String?, lastName: String?, headline: String?, phoneNo: String?, location: String?, zipCode: String?, services: String?, isChef: Bool?, isCustomer: Bool?)
    case finishYourProfileCall(firstName: String?, lastName: String?, headline: String?, about: String?, email: String?, location: String?, phoneNo: String?, isChef: Bool?, isCustomer: Bool?)
    case searchServices(searchString: String, lat:String, lon: String)
    case getServices(userId: String)
    case addService(name: String, description: String?, userPreferenceId: Int)
    case editService(name: String, description: String?, serviceId: String)
    case deleteService(serviceId: String)
    
    
    func httpBodyEnvelop()->[String:Any]? {
        
        switch self {
        case .listOfUsers(userType: let userType):
            
            return ["userType": userType]
            
        case .signInCall(userName: let userName, password: let password):
            return ["username": userName, "password": password]
            
        case .signUpCall(email: let email, password: let password, phoneNo: let phoneNo, firstName: let firstName, lastName: let lastName, isChef: let isChef, isCustomer: let isCustomer, imageUrl: let imageUrl, zipCode: let zipCode):
            return ["email": email, "password": password, "phone": phoneNo ?? "", "firstName": firstName, "lastName": lastName, "isChef": isChef, "isCustomer": isCustomer, "imageUrl": imageUrl, "zipCode": zipCode]
        case .forgotPassword, .validate, .getUserById, .getPhotoGallery, .deletePhotoFromGallery, .getServices, .deleteService, .searchServices:
            return nil
        
        case .resetPassword(email: let email, code: let code, password: let password):
            return ["email": email, "code": code, "password": password]
            
        case .updateUserPreferenceCall(let firstName, let lastName, let headline, let phoneNo, let location, let zipCode, let services, let isChef, let isCustomer):
            return ["firstName": firstName ?? "", "lastName": lastName ?? "" , "phone": phoneNo ?? "" , "headertext": headline ?? "", "location": location ?? "", "zipCode": zipCode ?? "", "services": services ?? "", "isChef": isChef ?? "", "isCustomer": isCustomer ?? ""]
            
        case .finishYourProfileCall(let firstName, let lastName, let headline, let about, let email, let location, let phoneNo, let isChef, let isCustomer):
            return ["firstName": firstName ?? "", "lastName": lastName ?? "", "headertext": headline ?? "", "about": about ?? "",  "email": email ?? "", "location": location ?? "", "phone": phoneNo ?? "", "isChef": isChef ?? "", "isCustomer": isCustomer ?? ""]
            
        case .addService(name: let name, description: let description, userPreferenceId: let userPreferenceId):
                return ["name": name, "description": description ?? "", "userPreferenceId": userPreferenceId]
            
        case .editService(name: let name, description: let description, serviceId: _):
            return ["name": name, "description": description ?? ""]
        }
    }
    
    /**
    Method to update the request url
    */
    func serviceEndpoint() -> String {
        switch self {
        case .forgotPassword(email: let email):
            return email
        case .validate(email: let email, code: let code):
            return email+"/"+code
        case .getUserById(userId: let userId):
            return "?userId=\(userId)"
        case .getPhotoGallery(userId: let userId):
            return "\(userId)"
        case .deletePhotoFromGallery(photoId: let photoId):
            return "\(photoId)"
        case .searchServices(searchString: let searchText, lat: let latitute, lon: let longitude):
            return "\(searchText)/\(latitute)/\(longitude)"
        case .getServices(userId: let userId):
            return "\(userId)"
        case .editService(name: _, description: _, serviceId: let serviceId):
             return "\(serviceId)"
        case .deleteService(serviceId: let serviceId):
             return "\(serviceId)"
        default:
            return "/"
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
