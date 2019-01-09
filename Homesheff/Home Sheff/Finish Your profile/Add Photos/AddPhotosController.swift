//
//  AddPhotosController.swift
//  Homesheff
//
//  Created by bkongara on 12/11/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import UIKit
import Photos
import NVActivityIndicatorView

class AddPhotosController: UIViewController {
    
    @IBOutlet weak var addPhotosBtn: UIButton!
    @IBOutlet weak var photosCollectionView: PhotosCollectionView!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var imagePicker = UIImagePickerController()
    let apiHandler = APIManager()
    let signInViewModel = SignInViewModel()

    var hideRightBarButton: Bool = false {
        didSet {
            if  self.hideRightBarButton {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            }
        }
    }
    var photoCollectionViewModel: PhotosCollectionViewModel!
    let photoEditor = Bundle.main.loadNibNamed("ImageEditor", owner: ImageEditor(), options: nil)![0] as? ImageEditor
    static var uploadedImageCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = .black
        activityIndicator.type = .ballClipRotate
        imagePicker.delegate = self
        photoEditor?.scrollView.delegate = photoEditor
        PhotosCollectionViewModel.shared.reloadCollectionView = { [weak self] in
            self?.photosCollectionView.reloadData()
        }
        photoEditor?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    static func create() -> AddPhotosController {
        let storyboard = UIStoryboard(name: "FinishYourProfile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPhotosController") as!  AddPhotosController
        return vc
    }
     
    override func viewWillAppear(_ animated: Bool) {
        self.photosCollectionView.delegate = self.photosCollectionView
        self.photosCollectionView.dataSource = self.photosCollectionView
        self.photosCollectionView.collectionDelegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Add Photos"
    }
    
   
    
    @IBAction func addPhotosClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        })
        takePhotoAction.setValue( UIImage(named: "Take Photo Icon", in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(takePhotoAction)
    
        let  photoLibraryAction =  UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openGallary()
        })
        photoLibraryAction.setValue( UIImage(named: "Photo Library Icon", in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(photoLibraryAction)
        
        let browseAction = UIAlertAction(title: "Browse", style: .default, handler: { _ in
            self.openGallary()
        })
        browseAction.setValue( UIImage(named: "Browse Icon", in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(browseAction)
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
    
    @IBAction func navigateToChefList(_ sender: Any) {
        self.signInViewModel.autoSignIn(envelop: self.signInViewModel.autoSignInEnvelop(userId:UserDefaults.standard.integer(forKey: "userId") )) { (success) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarControllerId") as! BaseTabbarController
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    
}



extension AddPhotosController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        DispatchQueue.main.async {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.dismiss(animated: true, completion: { () -> Void in
                    self.activityIndicator.startAnimating()
                    PhotosCollectionViewModel.shared.uploadImage(image: image, completion: { (success) in
                        self.activityIndicator.stopAnimating()
                    })
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddPhotosController: PhotosCollectionViewDelegate {
    
    func cellClicked(clickedImage: UIImage, imageId: Int) {
        photoEditor?.frame = self.view.frame
        photoEditor?.imageView.image = clickedImage
        photoEditor?.imageId = imageId
        self.view.addSubview(photoEditor!)
        self.navigationController?.isNavigationBarHidden = true
        self.view.bringSubview(toFront: photoEditor!)
    }
}

extension AddPhotosController: ImageEditorDelegate {
    func optionsClicked(imageId: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { _ in
            self.activityIndicator.startAnimating()
            PhotosCollectionViewModel.shared.deletePhotosFromGallery(envelop: PhotosCollectionViewModel.shared.deletePhotosFromGalleryEnvelop(photoId: imageId) , completion: { (success) in
                if success {
                    self.activityIndicator.stopAnimating()
                    PhotosCollectionViewModel.shared.removeImageData(photoId: imageId)
                    PhotosCollectionViewModel.shared.reloadCollectionView!()
                    self.photoEditor?.removeFromSuperview()
                    self.navigationController?.isNavigationBarHidden = false
                }
            })
        }))
        
//        alert.addAction(UIAlertAction(title: "Resize", style: .default, handler: { _ in
//
//        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func closeClicked() {
       self.photoEditor?.removeFromSuperview()
        self.navigationController?.isNavigationBarHidden = false
    }
}
