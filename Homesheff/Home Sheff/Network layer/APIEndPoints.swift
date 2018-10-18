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
  var apiPath:String { return "getListOfUsers/all" }
  var httpType:HttpType { return .get }
  var pathType : ServicePath
}

struct SignInEnvelop:Requestable {
    var apiPath:String { return "getUserByUsernamePassword" }
    var httpType:HttpType { return .get }
    var pathType : ServicePath
}


/*
 ALL services post dictionary is mentioned under enum switch statement.
 These cases get their values in ViewController (or respective controller or other class).
 This enum also wrap a method which provides dictionary for post body.
 */
internal enum ServicePath:ParameterBodyMaker {
  
  case listOfUsers(userType: String)
  case signInCall(userName: String, password: String)
  
  func httpBodyEnvelop()->[String:Any]? {
    
    switch self {
    case .listOfUsers(userType: let userType):
      
      return ["userType": userType]
      
    case .signInCall(userName: let userName, password: let password):
        return ["username": userName, "password": password]
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
