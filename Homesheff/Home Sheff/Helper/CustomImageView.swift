//
//  CustomImageView.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/27/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class CustomImageView: UIImageView {
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
    func loadImageWithUrlString(urlString: String, completion: @escaping (Bool) -> ())  {
        
        if let profileImage = self.cachedImage(for: urlString) {
            self.image = profileImage
            completion(true)
            return
        }
        self.retrieveImage(for: urlString) { (image) in
            if let profileImage = image {
                self.image = profileImage
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func retrieveImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        let request = Alamofire.request(url)
        request.validate()
        request.responseData { (response) in
            if response.error == nil {
                print(response.result)
                // Show the downloaded image:
                if let data = response.data, let image = UIImage(data: data) {
                    completion(image)
                    self.cache(image, for: url)
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
    
    func downloadProfileImage(withId id:String) {
        let profileImageName = "\(id)_ProfilePhoto"
        let url = "https://api.dev.homesheff.com/v1/downloadFile/\(profileImageName)"
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true;
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
        if let profileImage = self.cachedImage(for: url) {
            self.image = profileImage
            return
        }
        self.retrieveImage(for: url) {[weak self] (image) in
            if let weakSelf = self {
                if let profileImage = image {
                    DispatchQueue.main.async {
                        weakSelf.image = profileImage
                    }
                }else {
                    DispatchQueue.main.async {
                        weakSelf.image = UIImage(named: "sheffs_list_placeholder")
                    }
                }
            }
        }
    }
}
