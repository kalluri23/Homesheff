//
//  APIEndPoints.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class APIManager {
    
    typealias LoginSuccessHanlder = (Bool) -> Void
    func signInApi(requestEnvelop:Requestable, completion: @escaping LoginSuccessHanlder)  {
        let request = Alamofire.request(
            requestEnvelop.requestURL()!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            headers: requestEnvelop.httpHeaders())
        request.validate()
            .responseString { response  in
                
                // if response.result == "null" {}
                switch response.result{
                case .success:
                    if response.result.value != nil {
                        if User.defaultUser.createUser(data: response.data) {
                            UserDefaults.standard.set(true, forKey: "userLoggedIn")
                            UserDefaults.standard.set(User.defaultUser.currentUser!.id, forKey: "userId")
                            completion(true)
                        } else {
                             completion(false)
                        }
                        
                    }
                case .failure:
                    completion(false)
                }
        }
    }
    
    func forgotPasswordApi(requestEnvelop:Requestable, completion: @escaping (Bool)->Void) {
        let request = Alamofire.request(requestEnvelop.requestURL()!, headers: requestEnvelop.httpHeaders())
        request.validate()
            .responseString{ (response) -> Void in
                
                switch response.result{
                case .success:
                    if let resultValue = response.result.value
                    {
                        print(resultValue)
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure:
                    if let error = response.error {
                        print(error.localizedDescription)
                    }
                    completion(false)
                }
        }
    }
    
    func validateCodeApi(requestEnvelop:Requestable, completion: @escaping (Bool)->Void) {
        let request = Alamofire.request(requestEnvelop.requestURL()!, headers: requestEnvelop.httpHeaders())
        request.validate()
            .responseString{ (response) -> Void in
                
                switch response.result{
                case .success:
                    if let resultValue = response.result.value
                    {
                        print(resultValue)
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure:
                    if let error = response.error {
                        print(error.localizedDescription)
                    }
                    completion(false)
                }
        }
    }
    
    func resetPasswordApi(requestEnvelop:Requestable, completion: @escaping (Bool) -> Void)  {
        let request = Alamofire.request(requestEnvelop.requestURL()!, method: .post, parameters: requestEnvelop.pathType.httpBodyEnvelop()!, encoding: JSONEncoding.default, headers: requestEnvelop.httpHeaders()!)
        request.validate()
            .responseString{ (response) -> Void in
                
                switch response.result{
                case .success:
                    if let resultValue = response.result.value
                    {
                        print(resultValue)
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure:
                    if let error = response.error {
                        print(error.localizedDescription)
                    }
                    completion(false)
                }
        }
        
    }
    
    func signUpCall(requestEnvelop:Requestable, completion: @escaping (Bool) -> Void)  {
        
        let method = requestEnvelop.httpType.rawValue
        let type = HTTPMethod(rawValue: method)
        
       let request = Alamofire.request(
            requestEnvelop.requestURL()!,
            method: type!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            encoding: JSONEncoding.default,
            headers: requestEnvelop.httpHeaders())
        request.validate()
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
    
    func getUserById(requestEnvelop:Requestable, completion: @escaping LoginSuccessHanlder) {
        let request = Alamofire.request(
            requestEnvelop.requestURL()!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            headers: requestEnvelop.httpHeaders())
        request.validate()
            .responseString { response  in
                
                switch response.result{
                case .success:
                    if response.result.value != nil {
                        if User.defaultUser.createUser(data: response.data) {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                case .failure:
                    completion(false)
                }
        }
    }
    
    func updateUserPreferenceCall(requestEnvelop:Requestable, completion: @escaping (Bool) -> Void)  {
        
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
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
}

// Mark: Photos upload & Download

extension APIManager {
    
    func uploadPhoto(_ photo: UIImage, fileName: String, completionHandler: @escaping(_ success: Bool) -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let imageData = UIImageJPEGRepresentation(photo, 0.1)
            if let imageData = imageData {
                multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: "https://api.dev.homesheff.com/v1/uploadFile", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    if response.value == "File is uploaded successfully" {
                        completionHandler(true)
                    }
                    else {
                        completionHandler(false)
                    }
                }
            case .failure(_):
                completionHandler(false)
            }
        }
    }
    
    func retrieveImage(for imageName: String, completion: @escaping (UIImage?) -> Void) {
        let url = "https://api.dev.homesheff.com/v1/downloadFile/\(imageName)"
        Alamofire.request(url).responseData { (response) in
            if response.error == nil {
                print(response.result)
                // Show the downloaded image:
                if let data = response.data {
                    completion(UIImage(data: data))
                    self.cache(UIImage(data: data), for: url)
                }
            }
        }
    }
    
    //MARK: = Image Caching
    
    func cache(_ image: Image?, for url: String) {
        guard let image = image else {
            return
        }
        imageCache.add(image, withIdentifier: url)
    }
    
    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }
    
    func resetCacheFor(imageName: String) {
        let url = "https://api.dev.homesheff.com/v1/downloadFile/\(imageName)"
        imageCache.removeImage(withIdentifier: url)
    }
}

extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
    
}


