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
    }
    
    func getPhotoAtIndex(index: Int) -> PhotoData {
        return self.photoData[index]
    }
    
    func uploadImage(image: UIImage) {
        self.apiHandler.savePhotoToGallery(image) { (photoData, status)  in
            if status {
                self.adddImage(imageData: photoData!)
                self.reloadCollectionView!()
            } else {
                
            }
        }
    }
}
