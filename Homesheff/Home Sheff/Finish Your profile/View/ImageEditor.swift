//
//  ImageViewer.swift
//  Homesheff
//
//  Created by bkongara on 12/12/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit

protocol ImageEditorDelegate: class {
    func optionsClicked(imageId: Int)
    func closeClicked()
}

class ImageEditor: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var optionsBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    weak var delegate: ImageEditorDelegate?
    var imageId: Int?

    @IBAction func optionsClicked(_ sender: Any) {
        self.delegate?.optionsClicked(imageId: self.imageId!)
    }
    
    
    @IBAction func closeClicked(_ sender: Any) {
        self.delegate?.closeClicked()
    }
    
    
}

extension ImageEditor: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
