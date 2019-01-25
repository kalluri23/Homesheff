//
//  PhotoGalleryCell.swift
//  Homesheff
//
//  Created by bkongara on 12/23/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

protocol PhotoGalleryDelegate: AnyObject {
    func editPhotosClicked()
}

class PhotoGalleryCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noPhotosLbl: UILabel!
    
    var noPhotosLabel:UILabel?
    
    weak var delegate: PhotoGalleryDelegate?
    var isEditable:Bool = false {
        didSet {
            if !isEditable {
                self.heightConstraint.constant = 0
                self.updateConstraints()
            }
        }
    }
    var photoList: [PhotoData]? {
        didSet {
            if let list = photoList, list.count == 0 {
                noPhotosLabel!.text = "No photos available"
                self.addSubview(noPhotosLabel!)
            } else {
                noPhotosLabel!.removeFromSuperview()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.noPhotosLabel = UILabel(frame: CGRect(x:10, y:55, width:self.collectionView.frame.width, height: 21))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editPhotos() {
        self.delegate?.editPhotosClicked()
    }

}

extension PhotoGalleryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photoList = self.photoList else {
            return 0
        }
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        if let photoList = self.photoList {
            let photoData = photoList[indexPath.row]
            galleryCell.activityIndicator?.startAnimating()
            galleryCell.imageView?.loadImageWithUrlString(urlString: photoData.imageUrl!, completion: { (success) in
                galleryCell.activityIndicator?.stopAnimating()
                galleryCell.activityIndicator?.alpha = 0.0
            })
            return galleryCell
        }else {
            return galleryCell
        }
    }
    
}
