//
//  ImagePicker.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/9.
//

import Foundation
import UIKit
class ImagePicker: UIViewController {
    let uiImagePickerController = UIImagePickerController()
    var slcImage = UIImage()
    var rootViewController = UIViewController()
    
    func setup(_rootViewController: UIViewController) {
        rootViewController = _rootViewController
        slcImage = UIImage()
        uiImagePickerController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fatalError("viewDidLoad Should not Be Called")
    }
    
    enum PickingError: Error {
        case cameraNotAvailable
    }
    
    func pickFromLib() throws {
        print("From Lib")
    }
    
    func takeFromCamera() throws {
        print("From Camera")
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            didFinishSelecting()
            return
//            throw PickingError.cameraNotAvailable
        }
        
        uiImagePickerController.sourceType = .camera
        uiImagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        rootViewController.present(uiImagePickerController, animated: true)
    }
    
    func retrieveImage() -> UIImage {
        return slcImage
    }
    
    func didFinishSelecting() {
        rootViewController.dismiss(animated: true)
        let cvc = CropViewController()
        let navi = UINavigationController(rootViewController: cvc)
        navi.modalPresentationStyle = .fullScreen
        rootViewController.present(navi, animated: true)
//        cvc.modalPresentationStyle = .fullScreen
//        rootViewController.present(cvc, animated: true)
    }
}


extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        slcImage = image
        didFinishSelecting()
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
