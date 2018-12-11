//
//  AddPhotosController.swift
//  Homesheff
//
//  Created by bkongara on 12/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import Photos

class AddPhotosController: UIViewController {
    
    @IBOutlet weak var addPhotosBtn: UIButton!
    @IBOutlet weak var photosCollectionView: PhotosCollectionView!
    var imagePicker = UIImagePickerController()
    var photoCollectionViewModel: PhotosCollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
       PhotosCollectionViewModel.shared.reloadCollectionView = { [weak self] in
            self?.photosCollectionView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photosCollectionView.delegate = self.photosCollectionView
        self.photosCollectionView.dataSource = self.photosCollectionView
    }
    
   
    
    @IBAction func addPhotosClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "Browse", style: .default, handler: { _ in
             self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func browseGallery() {
        checkPermission { (permission) in
            if permission {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = .camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallary(){
        checkPermission { (permission) in
            if permission {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func checkPermission(completionHandler: ((Bool) -> Void)? = nil) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
           completionHandler!(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    completionHandler!(true)
                }
            })
            print("It is not determined until now")
        case .restricted:
            completionHandler!(false)
        case .denied:
             completionHandler!(false)
        }
    }
}

extension AddPhotosController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        DispatchQueue.main.async {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.dismiss(animated: true, completion: { () -> Void in
                    PhotosCollectionViewModel.shared.adddImage(image: image)
                     PhotosCollectionViewModel.shared.reloadCollectionView!()
                })
            }
           
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
