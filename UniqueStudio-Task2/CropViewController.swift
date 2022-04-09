//
//  CropViewController.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/9.
//

import UIKit

class CropViewController: UIViewController {
    let imageView = UIImageView()
    let rectView = UIView()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(rectView)
        title = "编辑"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "book.closed")
        
        rectView.frame.size = CGSize(width: screenWidth, height: screenWidth)
        rectView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        rectView.swiftDrawBoardDottedLine(width: 3, lenth: 3, space: 3, cornerRadius: 3, color: .black)
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3 / 5),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        view.addConstraints(constraints)

    }
    
    @objc func back() {
        dismiss(animated: true)
    }
}

extension CropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}


//画虚线框
extension UIView{
    func swiftDrawBoardDottedLine(width:CGFloat,lenth:CGFloat,space:CGFloat,cornerRadius:CGFloat,color:UIColor){
        self.layer.cornerRadius = cornerRadius
        let borderLayer =  CAShapeLayer()
        borderLayer.bounds = self.bounds
        
        borderLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY);
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        borderLayer.lineWidth = width / UIScreen.main.scale
        
        //虚线边框---小边框的长度
        
        borderLayer.lineDashPattern = [lenth,space] as? [NSNumber] //前边是虚线的长度，后边是虚线之间空隙的长度
        borderLayer.lineDashPhase = 0.1;
        //实线边框
        
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        self.layer.addSublayer(borderLayer)
        
    }
}
