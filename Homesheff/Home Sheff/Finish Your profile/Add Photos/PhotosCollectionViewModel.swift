//
//  PhotosCollectionViewModel.swift
//  Homesheff
//
//  Created by bkongara on 12/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class PhotosCollectionViewModel: NSObject {
    
    static let shared = PhotosCollectionViewModel()
     let apiHandler = APIManager()
    var reloadCollectionView: (() -> Void)?
    var photoData:[PhotoData] =  [PhotoData]()
    var imageList = [UIImage]()
    var numberOfRows: Int {
        return self.photoData.count
    }
    
    override init() {
        super.init()
        if ((User.defaultUser.currentUser?.photoGallery) != nil) {
            self.photoData = (User.defaultUser.currentUser?.photoGallery)!
        }
    }
    
    func adddImage(imageData:
        PhotoData) {
        self.photoData.append(imageData)
        User.defaultUser.currentUser?.photoGallery = self.photoData
    }
    
    func removeImageData(photoId: Int) {
        self.photoData.removeAll { (data) -> Bool in
            data.id == photoId
        }
        User.defaultUser.currentUser?.photoGallery = self.photoData
    }
    
    func getPhotoAtIndex(index: Int) -> PhotoData {
        return self.photoData[index]
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Bool) -> ()) {
        self.apiHandler.savePhotoToGallery(image, userId: (User.defaultUser.currentUser?.id)!) { (photoData, status)  in
            if status {
                self.adddImage(imageData: photoData!)
                self.reloadCollectionView!()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func deletePhotosFromGalleryEnvelop(photoId: Int) -> Requestable {
        let searchPath = ServicePath.deletePhotoFromGallery(photoId: photoId)
        let photoGalleryEnvelop = DeletePhotoFromGallery(pathType: searchPath)
        return photoGalleryEnvelop
    }
    
    func  deletePhotosFromGallery(envelop:Requestable, completion: @escaping (Bool) -> Void) {
        apiHandler.deletePhotoFromGallery(requestEnvelop: envelop, completion: completion)
    }

}
