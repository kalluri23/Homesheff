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
    var photoData = [PhotoData]()
    let noPhotosView = Bundle.main.loadNibNamed("EmptyCollectionView", owner: EmptyCollectionView(), options: nil)![0] as? UIView
    override func awakeFromNib() {
       // self.addSubview(noPhotosView!)
    }
    
}


extension PhotosCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if PhotosCollectionViewModel.shared.numberOfRows == 0 {
            self.noPhotosView!.alpha = 1.0
            return PhotosCollectionViewModel.shared.numberOfRows
        }
        self.noPhotosView!.alpha = 0
        self.sendSubview(toBack: self.noPhotosView!)
        return PhotosCollectionViewModel.shared.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell =  collectionView.cellForItem(at: indexPath) as! PhotoCollectionCell
        self.collectionDelegate?.cellClicked(clickedImage: (cell.imageView?.image)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let photoCell:PhotoCollectionCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        let photoData = PhotosCollectionViewModel.shared.getPhotoAtIndex(index: indexPath.row)
        photoCell.imageView?.loadImageWithUrlString(urlString: photoData.imageUrl!)
        // photoCell.imageView.image = PhotosCollectionViewModel.shared.imageList[indexPath.row]
        return photoCell
    }
    
}
