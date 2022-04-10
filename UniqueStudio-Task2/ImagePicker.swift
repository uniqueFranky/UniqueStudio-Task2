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
    var userCancelled = false
    var failReason = PickingError.noError
    func setup(_rootViewController: UIViewController, mode: UIImagePickerController.SourceType) {
        rootViewController = _rootViewController
        slcImage = UIImage()
        uiImagePickerController.delegate = self
        uiImagePickerController.sourceType = mode
        rootViewController.present(self, animated: true)
        try! takeFromCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fatalError("viewDidLoad Should not Be Called")
        print("pickerView didLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("pickerView didAppear")

    }
    
    enum PickingError: Error {
        case noError
        case cameraNotAvailable
        case userCancelled
    }
    
    func pickFromLib() throws {
        print("From Lib")
    }
    
    func takeFromCamera() throws {
        print("From Camera")
        failReason = PickingError.noError
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            failReason = PickingError.cameraNotAvailable
            return
        }
        userCancelled = false
        uiImagePickerController.sourceType = .camera
        uiImagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(uiImagePickerController, animated: true)

    }
    
    func retrieveImage() -> UIImage {
        if failReason != PickingError.noError {
            print("Failed to get image")
            return UIImage()
        } else {
            return slcImage
        }
    }
    
    func didFinishSelecting() {
       
        dismiss(animated: true)
        let cvc = CropViewController()
        cvc.setupImageView(image: slcImage)
        let navi = UINavigationController(rootViewController: cvc)
        navi.modalPresentationStyle = .fullScreen
        
        //TODO: 这里要先dissmis，再present，研究一下为什么
        dismiss(animated: true)
        present(navi, animated: true)
    }
}


extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No Available Image")
            return
        }
        print("Finish Taking")
        slcImage = image
        didFinishSelecting()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        dismiss(animated: true)
        print("cancelled")
        failReason = PickingError.userCancelled
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
