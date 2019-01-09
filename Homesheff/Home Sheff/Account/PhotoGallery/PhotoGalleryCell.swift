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
    var isEditable:Bool = false
    var photoList: [PhotoData] = [PhotoData]() {
        didSet {
            if photoList.count == 0 {
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !isEditable {
            self.heightConstraint.constant = 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        return self.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        let photoData = self.photoList[indexPath.row]
        galleryCell.activityIndicator?.startAnimating()
        galleryCell.imageView?.loadImageWithUrlString(urlString: photoData.imageUrl!, completion: { (success) in
            galleryCell.activityIndicator?.stopAnimating()
            galleryCell.activityIndicator?.alpha = 0.0
        })
        return galleryCell
    }
    
}
