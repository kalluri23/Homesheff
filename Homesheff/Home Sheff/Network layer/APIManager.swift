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
                            
                            print(error)
                        }
                        
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
