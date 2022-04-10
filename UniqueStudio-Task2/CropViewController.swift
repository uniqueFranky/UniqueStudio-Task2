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
    let scrollView = UIScrollView()
    let upperRectView = UIView()
    let lowerRectView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "编辑"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        view.backgroundColor = .clear
        configureMidRectView()
        configureScrollView()
        configureImageView()
        configureBoundRectView()
//        let constraints = [
//            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3 / 5),
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ]
//        view.addConstraints(constraints)

    }
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
//        scrollView.bouncesZoom = true
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
//        scrollView.frame.size = CGSize(width: screenWidth, height: screenHeight)
        scrollView.contentMode = .scaleAspectFill
        
        //MARK: !!!!!!!!!!!!!!!!!!!!!!!!!
        scrollView.clipsToBounds = false
    }
    func configureImageView() {
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
    }
    func configureMidRectView() {

        view.addSubview(rectView)
        rectView.frame.size = CGSize(width: screenWidth, height: screenWidth)
        rectView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        rectView.swiftDrawBoardDottedLine(width: 3, lenth: 3, space: 3, cornerRadius: 3, color: .black)
        rectView.backgroundColor = .clear

    }
    
    func configureBoundRectView() {
        view.addSubview(upperRectView)
        view.addSubview(lowerRectView)
        upperRectView.frame.size = CGSize(width: screenWidth, height: (screenHeight - screenWidth) / 2)
        upperRectView.frame.origin = CGPoint(x: 0, y: 0)
        upperRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        lowerRectView.frame.size = CGSize(width: screenWidth, height: (screenHeight - screenWidth) / 2)
        lowerRectView.frame.origin = CGPoint(x: 0, y: (screenHeight + screenWidth) / 2)
        lowerRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    
    func setupImageView(image: UIImage) {
        imageView.image = image
    }
    
    @objc func back() {
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("!@#!@#", scrollView.contentScaleFactor, imageView.frame.size, scrollView.contentOffset, scrollView.contentSize, imageView.image?.size)
        if imageView.image!.size.width >= imageView.image!.size.height {
            let ratio = imageView.image!.size.width / imageView.image!.size.height
            imageView.frame.size = CGSize(width: screenWidth * ratio, height: screenWidth)
        } else {
            let ratio = imageView.image!.size.height / imageView.image!.size.width
            imageView.frame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
        }

        scrollView.contentSize = imageView.frame.size
//        scrollView.frame.size = imageView.frame.size
        scrollView.frame.size = CGSize(width: screenWidth, height: screenWidth)
        scrollView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)

        scrollView.contentSize = imageView.frame.size
        if imageView.frame.size.width == screenWidth {
            scrollView.contentOffset.y = imageView.frame.size.height / 8
        } else {
            scrollView.contentOffset.x = imageView.frame.size.width / 8
        }
        print("SettingUp",scrollView.contentOffset)

    }
}

extension CropViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("AfterScroll",scrollView.contentOffset)

    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        upperRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        lowerRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        upperRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        lowerRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        upperRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        lowerRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("endDragging")
        upperRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        lowerRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("zoomed")

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
