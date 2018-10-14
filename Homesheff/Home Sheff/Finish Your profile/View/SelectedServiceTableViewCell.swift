//
//  SelectedServiceTableViewCell.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/10/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

class SelectedServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceCollectionView: UICollectionView!
    
    var services: AddServiceFields? {
        didSet{
            serviceCollectionView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        serviceCollectionView.register(SelectedServicesCollectionViewCell.nib, forCellWithReuseIdentifier: SelectedServicesCollectionViewCell.reuseIdentifier)
            //    serviceCollectionView.register(CollectionReusableView.nib, forCellWithReuseIdentifier: "headerId")
        serviceCollectionView.register(CollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "headerId")
        
//        if let flowLayout = serviceCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1 , height: 1);
//        }
        serviceCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        let attributes = [NSAttributedStringKey.font:self,]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
    }
}

extension SelectedServiceTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return services?.selectedService?.count ?? 0
        }
        return services?.defaultService.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10,10,0,5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = services?.defaultService[indexPath.item].name ?? ""
        let width = UILabel.textWidth(font: UIFont(name: "Helvetica Neue", size: 14)!, text: text)
        return CGSize(width: width  + 40, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: 0, height: 0)
        }
        
        return CGSize(width: collectionView.frame.size.width, height: 20)
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell: SelectedServicesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        var string = "Default value"
        switch indexPath.section {
        case 0:
            string = services?.selectedService?[indexPath.item].name ?? ""
            cell.contentBackgroundColor = .appDefaultColor
        case 1:
            string = services?.defaultService[indexPath.item].name ?? ""
            cell.contentBackgroundColor = .white
        default:
            string = "Chef"
        }
        
           cell.serviceLabel.text = string
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var v : CollectionReusableView! = nil
        if kind == UICollectionElementKindSectionFooter{
            v  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "headerId", for: indexPath) as? CollectionReusableView
            
            if indexPath.section == 0 {
                v.headerLabel.text = "Suggested chef services"
          }
        }
        return v
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard var serviceAdded = services?.defaultService[indexPath.item] else { return }
//        if serviceAdded.isSelected == false {
//        services?.selectedService?.append(serviceAdded)
//        serviceAdded.isSelected = true
//      }
    }
}



