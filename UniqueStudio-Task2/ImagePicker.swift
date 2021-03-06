//
//  ImagePicker.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/9.
//

import Foundation
import UIKit
import CloudKit
import Photos

class ImagePicker: UIViewController {
    let uiImagePickerController = UIImagePickerController()
    var image = UIImage()
    var rootViewController = UIViewController()
    var authStatus: PHAuthorizationStatus!
    var failReason = PickingError.invalidImage
    var callBack: () -> Void = {
        
    }
    var isValid: (_ toJudge: UIImage) -> Bool = { toJudge in
        return true
    }
    enum PickingError: Error {
        case noError
        case cameraNotAvailable
        case libraryNotAvailable
        case userCancelled
        case invalidImage
        case invalidDir
        case invalidSize
        case uncroppedImage
        case accessDenied
    }
    
    func requestAuth() {
        PHAsset.fetchAssets(with: nil)
        PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }
    
    func settingUp(_rootViewController: UIViewController, mode: UIImagePickerController.SourceType, callBack: @escaping () -> Void) {
        rootViewController = _rootViewController
        self.modalPresentationStyle = .fullScreen
        uiImagePickerController.delegate = self
        self.callBack = callBack
        authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if authStatus == .denied {
            print("!!Denied!!")
            failReason = .accessDenied
            callBack()
            return
        }
        if mode == .camera {
            takeFromCamera()
        } else {
            pickFromLib()
        }
    }
    
    func setup(_rootViewController: UIViewController, mode: UIImagePickerController.SourceType, callBack: @escaping () -> Void, isValid: @escaping (_ toJudge: UIImage) -> Bool) {
        rootViewController = _rootViewController
        self.modalPresentationStyle = .fullScreen
        uiImagePickerController.delegate = self
        self.callBack = callBack
        self.isValid = isValid
        authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if authStatus == .denied {
            print("!!Denied!!")
            failReason = .accessDenied
            callBack()
            return
        }
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
            callBack()
            return
        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width:  UIScreen.main.bounds.width / 4 - 5, height:  UIScreen.main.bounds.width / 4 - 5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        let lbvc = LibraryBrowserViewController(collectionViewLayout: layout)
        lbvc.setPicker(picker: self)
        let navi = UINavigationController(rootViewController: lbvc)
        navi.modalPresentationStyle = .fullScreen
        rootViewController.present(navi, animated: true)
    }
    
    func takeFromCamera() {
        print("From Camera")
        failReason = PickingError.noError
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            failReason = PickingError.cameraNotAvailable
            callBack()
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
            failReason = .invalidImage
            callBack()
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
        callBack()
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
