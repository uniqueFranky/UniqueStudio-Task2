//
//  ImagePicker.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/9.
//

import Foundation
import UIKit
import CloudKit

class ImagePicker: UIViewController {
    let uiImagePickerController = UIImagePickerController()
    var image = UIImage()
    var rootViewController = UIViewController()
    var failReason = PickingError.invalidImage
    
    enum PickingError: Error {
        case noError
        case cameraNotAvailable
        case libraryNotAvailable
        case userCancelled
        case invalidImage
        case invalidDir
        case invalidSize
    }
    
    func setup(_rootViewController: UIViewController, mode: UIImagePickerController.SourceType) {
        rootViewController = _rootViewController
        self.modalPresentationStyle = .fullScreen
        uiImagePickerController.delegate = self
//        rootViewController.present(self, animated: true)
        if mode == .camera {
            takeFromCamera()
        } else {
            pickFromLib()
        }
    }
    

    
    func pickFromLib()  {
        print("From Lib")
        failReason = PickingError.noError
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            failReason = PickingError.libraryNotAvailable
            return
        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 80, height: 80)
        let lbvc = LibraryBrowserViewController(collectionViewLayout: layout)
        lbvc.setPicker(picker: self)
        rootViewController.present(lbvc, animated: true)
    }
    
    func takeFromCamera() {
        print("From Camera")
        failReason = PickingError.noError
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            failReason = PickingError.cameraNotAvailable
            return
        }
        uiImagePickerController.sourceType = .camera
        uiImagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        rootViewController.present(uiImagePickerController, animated: true)

    }
    
    func retrieveImage() throws -> UIImage {
        if failReason != PickingError.noError {
            throw failReason
        } else if image == UIImage() {
            throw PickingError.invalidImage
        }
        return image
    }
    
    func didFinishSelecting() {
       
        let cvc = CropViewController()
        cvc.setupImageView(image: image)
        cvc.setPicker(self)
        let navi = UINavigationController(rootViewController: cvc)
        navi.modalPresentationStyle = .fullScreen
        
        rootViewController.present(navi, animated: true)
    }
}


extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        rootViewController.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No Available Image")
            return
        }
        print("Finish Taking")
        self.image = image
        didFinishSelecting()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        rootViewController.dismiss(animated: true)
        print("cancelled")
        failReason = PickingError.userCancelled
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
