//
//  UserProfileViewModel.swift
//  Homesheff
//
//  Created by Anurag Pandey on 11/3/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class UserProfileViewModel {
    
    let apiHandler = APIManager()
    var bind: (() -> Void)?
    var userProfilePhotoData: Data?
    var currentUser = User.defaultUser.currentUser
    
    func updateUserProfile(envelop:Requestable, completion: @escaping (Bool) -> Void ) {
        apiHandler.updateUserPreferenceCall(requestEnvelop: envelop, completion: completion)
    }
    
    func uploadPhoto(photo: UIImage, photoName: String) {
        let completePhotoName = "\(currentUser?.id ?? 0)_\(photoName)"
        apiHandler.uploadPhoto(photo, fileName: completePhotoName) { (isSuccess) in
            self.apiHandler.resetCacheFor(imageName: completePhotoName)
        }
    }
    
    func downloadImage(imageName:String, completion: @escaping (UIImage) -> ()) {
        if let image = apiHandler.cachedImage(for: imageName) {
            completion(image)
            return
        }
        apiHandler.retrieveImage(for: imageName) { (image) in
            if let image = image {
                completion(image)
            }
        }
    }
}
