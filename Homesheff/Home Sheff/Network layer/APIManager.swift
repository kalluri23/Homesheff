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
    static let  baseUrl = "https://api.dev.homesheff.com/v1"
    
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
    
    func searchServicesApi(requestEnvelop:Requestable, completion: @escaping ([ChefService]?, Bool)->Void) {
        let request = Alamofire.request(requestEnvelop.requestURL()!)
        request.validate()
            .responseString{ (response) -> Void in
                switch response.result{
                case .success:
                    if let resultValue = response.result.value, let data = response.data
                    {
                        do {
                            let decoder = JSONDecoder()
                            let services = try decoder.decode([ChefService].self, from:
                                data) //Decode JSON Response Data
                            completion(services, true)
                        } catch let parsingError {
                            print(parsingError.localizedDescription)
                            completion(nil, false)
                        }
                        print(resultValue)
                    } else {
                        completion(nil, false)
                    }
                case .failure:
                    if let error = response.error {
                        print(error.localizedDescription)
                    }
                    completion(nil, false)
                }
        }
    }
    
    func searchApi(location: String, completion: @escaping ([Location]?)->Void) {
        let requestURL = "https://dev.servpal.com/api/search/location"
        let requestHeaders = ["Content-Type": "application/json", "X-Requested-With":"XMLHttpRequest"]
        let request = Alamofire.request(
            requestURL,
            parameters:["q":location],
            headers: requestHeaders)
        request.validate()
            .responseString{ (response) -> Void in
                
                switch response.result{
                case .success:
                    if let resultValue = response.result.value, let data = response.data
                    {
                        do {
                            let decoder = JSONDecoder()
                            let locations = try decoder.decode([Location].self, from:
                                data) //Decode JSON Response Data
                            completion(locations)
                        } catch let parsingError {
                            print(parsingError.localizedDescription)
                            completion(nil)
                        }
                        print(resultValue)
                    } else {
                        completion(nil)
                    }
                case .failure:
                    if let error = response.error {
                        print(error.localizedDescription)
                    }
                    completion(nil)
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
                    if let resultValue = response.result.value {
                        print(resultValue)
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
        let request = Alamofire.request(url)
        request.validate()
        request.responseData { (response) in
            if response.error == nil {
                print(response.result)
                // Show the downloaded image:
                if let data = response.data, let image = UIImage(data: data) {
                    completion(image)
                    self.cache(image, for: url)
                }
            }
        }
    }
    
    func downLoadFBProfileImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        Alamofire.request(url).responseData { (response) in
            if response.error == nil {
                print(response.result)
                if let data = response.data {
                    completion(UIImage(data: data))
                }else {
                    completion(nil)
                }
            }else {
                completion(nil)
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

// refactor below to be generic image upload if possible

extension APIManager {
    
    func savePhotoToGallery(_ photo: UIImage, userId: Int, completionHandler: @escaping(_ photoData: PhotoData?, _ success: Bool) -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let imageData = UIImageJPEGRepresentation(photo, 0.1)
            if let imageData = imageData {
                multipartFormData.append(imageData, withName: "file", fileName: "file.jpeg",  mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: "\(APIManager.baseUrl)/savePhotoToGallery/\(userId)", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                print ("image uploded")
                upload.responseString { response in
                    do {
                        print(response.result)
                        let jsonDecoder = JSONDecoder()
                        let photoData = try jsonDecoder.decode(PhotoData.self, from: response.data!)
                        completionHandler(photoData, true)
                    }
                    catch {
                        print(error)
                        completionHandler(nil, false)
                    }
                }
            case .failure(_):
                completionHandler(nil, false)
            }
        }
    }
    
    func getPhotoGallery(requestEnvelop:Requestable, completion: @escaping ([PhotoData]?) -> Void)  {
        
        let method = requestEnvelop.httpType.rawValue
        let type = HTTPMethod(rawValue: method)
        
        Alamofire.request(
            requestEnvelop.requestURL()!,
            method: type!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            encoding: JSONEncoding.default,
            headers: requestEnvelop.httpHeaders()).responseString { (response) in
                switch response.result  {
                    case .success:
                        if response.result.value != nil {
                            do {
                                print(response.result)
                                let jsonDecoder = JSONDecoder()
                                let list = try jsonDecoder.decode([PhotoData].self, from: response.data!)
                                completion(list)
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
    
    func deletePhotoFromGallery(requestEnvelop:Requestable, completion: @escaping (_ success: Bool) -> Void) {
        let method = requestEnvelop.httpType.rawValue
        let type = HTTPMethod(rawValue: method)
        
        Alamofire.request(
            requestEnvelop.requestURL()!,
            method: type!,
            parameters: requestEnvelop.pathType.httpBodyEnvelop(),
            encoding: JSONEncoding.default,
            headers: requestEnvelop.httpHeaders()
        ).responseData { (response) in
            switch response.result  {
            case .success:
                if response.result.value != nil {
                    print(response.result)
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
    
}

extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
    
}


