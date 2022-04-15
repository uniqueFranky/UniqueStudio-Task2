//
//  ViewController.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/9.
//

import UIKit

class ViewController: UIViewController, UIActionSheetDelegate {
    
    //       ImagePicker
    let picker = ImagePicker()

    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureBarButtonItem()
        
        configureImageView()
//        picker.requestAuth()
    }
    
    func configureBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showSheet))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "显示选择的照片", style: .done, target: self, action: #selector(getImage))
    }
    
    func configureImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFit
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        view.addConstraints(constraints)
    }
    
    @objc func showSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "从图库选择", style: UIAlertAction.Style.default, handler: pickFromLib))
        alertController.addAction(UIAlertAction(title: "用相机拍摄", style: UIAlertAction.Style.default, handler: takeFromCamera))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel))
        present(alertController, animated: true)
    }

    @objc func getImage() {
        do {
            try imageView.image = picker.retrieveImage()
        } catch {
            let alert = UIAlertController(title: "未能成功获取照片", message: "失败原因：\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    func pickFromLib(paramAction: UIAlertAction) {
        picker.setup(_rootViewController: self, mode: UIImagePickerController.SourceType.photoLibrary, callBack: {
            self.getImage()
        })
    }
    func takeFromCamera(paramAction: UIAlertAction) {
        picker.setup(_rootViewController: self, mode: UIImagePickerController.SourceType.camera, callBack: {
            self.getImage()
        })
    }
    
}

