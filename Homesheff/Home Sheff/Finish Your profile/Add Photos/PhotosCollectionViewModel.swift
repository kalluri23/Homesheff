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
    
    var reloadCollectionView: (() -> Void)?
    var imageList = [UIImage]()
    var numberOfRows: Int {
        return imageList.count
    }
    
    override init() {
        super.init()
    }
    
    func adddImage(image: UIImage) {
        self.imageList.append(image)
    }
}
