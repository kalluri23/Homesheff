//
//  APIEndPoints.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    typealias LoginSuccessHanlder = (Bool) -> Void
    func signInApi(requestEnvelop:Requestable, completion: @escaping LoginSuccessHanlder)  {
        
        Alamofire.request(
            requestEnvelop.requestURL()!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            headers: requestEnvelop.httpHeaders()).validate()
            .responseString { response  in
                
               // if response.result == "null" {}
                switch response.result{
                   case .success:
                    if response.result.value != nil {
                        
                        do {
                            let jsonDecoder = JSONDecoder()
                            let list = try jsonDecoder.decode(User.self, from: response.data!)
                            UserDetailModal.sharedInstance.user = list
                            completion(true)
                        }
                        catch {
                            
                           completion(false)
                        }
                        
                    }
                      case .failure:
                    completion(false)
                }
    }
}
    
    func signUpCall(requestEnvelop:Requestable, completion: @escaping (Bool) -> Void)  {
        
        let method = requestEnvelop.httpType.rawValue
        let type = HTTPMethod(rawValue: method)
        
        Alamofire.request(
            requestEnvelop.requestURL()!,
            method: type!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            encoding: JSONEncoding.default,
            headers: requestEnvelop.httpHeaders())
            .responseString { (response) -> Void in
                
                switch response.result{
                case .success:
                    if let resultValue = response.result.value, resultValue == "success" {
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure:
                    completion(false)
                }
        }
    }
  
  typealias CompletionHandler = ([Chef]?,Bool) -> Void
  
  func fetchUserList(requestEnvelop:Requestable, completion: @escaping CompletionHandler) {
    
    //Alamofire.request(requestURL: requestEnvelop.requestURL, parameters: )
    Alamofire.request(
      requestEnvelop.requestURL()!,
      headers: requestEnvelop.httpHeaders()).validate()
        .responseString { response  in
            print(response)
        switch response.result  {

        case .success:
            if response.result.value != nil {
            
            do {
                let jsonDecoder = JSONDecoder()
                let list = try jsonDecoder.decode([Chef].self, from: response.data!)
               
                completion(list,true)
            }
            catch {
                
                print(error)
            }

          }

        case .failure(let error):
          print(error)
      }
    }
  }
}
