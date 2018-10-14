//
//  UITableViewGenericId.swift
//  Homesheff
//
//  Created by Anurag Yadev on 9/25/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

extension UITableViewCell:ReusableView {}
extension UICollectionViewCell: ReusableView{}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { fatalError("Unable to Dequeue Reusable Table View Cell") }
        
        return cell
    }
}
extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else  { fatalError("Unable to Dequeue Reusable Table View Cell")}
        
        return cell
    }
}
