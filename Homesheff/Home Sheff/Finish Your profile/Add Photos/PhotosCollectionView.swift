//
//  PhotosCollectionView.swift
//  Homesheff
//
//  Created by bkongara on 12/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

protocol PhotosCollectionViewDelegate: class {
    func cellClicked(clickedImage: UIImage)
}

class PhotosCollectionView: UICollectionView {
    
    weak var collectionDelegate: PhotosCollectionViewDelegate?

   var imageList = [UIImage]()
    let noPhotosView = Bundle.main.loadNibNamed("EmptyCollectionView", owner: EmptyCollectionView(), options: nil)![0] as? UIView
    override func awakeFromNib() {
        self.addSubview(noPhotosView!)
    }
    
}


extension PhotosCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if PhotosCollectionViewModel.shared.numberOfRows == 0 {
            self.noPhotosView!.alpha = 1.0
            return PhotosCollectionViewModel.shared.numberOfRows
        }
        self.noPhotosView!.alpha = 0
        return PhotosCollectionViewModel.shared.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionDelegate?.cellClicked(clickedImage: PhotosCollectionViewModel.shared.imageList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photoCell:PhotosCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        photoCell.imageView.image = PhotosCollectionViewModel.shared.imageList[indexPath.row]
        return photoCell
    }
    
}
