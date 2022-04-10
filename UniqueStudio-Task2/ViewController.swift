//
//  ViewController.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/9.
//

import UIKit

class ViewController: UIViewController, UIActionSheetDelegate {

    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(btn)

        btn.addTarget(self, action: #selector(showSheet), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SelectPic", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        let constraints = [
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 200),
            btn.heightAnchor.constraint(equalToConstant: 50),
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
    
    func pickFromLib(paramAction: UIAlertAction) {
        
    }
//    func takeFromCamera1(paramAction: UIAlertAction) {
//        print("Before 1")
//        takeFromCamera(paramAction: paramAction)
//        print("After 1")
//    }
    func takeFromCamera(paramAction: UIAlertAction) {
        let picker = ImagePicker()
        
        picker.setup(_rootViewController: self, mode: UIImagePickerController.SourceType.camera)
//        present(picker, animated: true)
        print("return to rootViewController")
        funcAfterReturning()
    }
    
    func funcAfterReturning() {
        print("funcAfterReturning")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("rootViewDidAppear")
    }
}

