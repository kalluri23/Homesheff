//
//  CustomImageView.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/27/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    
    let imageCache = NSCache<NSString, UIImage>()
    var imageUrlString: String?
    
    func loadImageWithUrlString(urlString: String, completion: @escaping (Bool) -> ())  {
        
        guard let url = URL(string: urlString) else { return }
        imageUrlString = urlString
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString){
            self.image = imageFromCache
            completion(true)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                self.imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                
                guard self.imageUrlString == urlString else {
                    return
                }
                self.image = imageToCache
                completion(true)
            }
            }.resume()
    }
}
