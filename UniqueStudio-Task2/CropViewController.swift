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
    var fatherPicker = ImagePicker()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "裁剪"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        configureMidRectView()
        configureScrollView()
        configureImageView()
        configureBoundRectView()
    }
    
    func setPicker(_ father: ImagePicker) {
        fatherPicker = father
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
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
    func cropImage(offset: CGPoint, ratio: Double) {
        let image = imageView.image!.fixOrientation()
        let cropRect = CGRect(x: offset.x * ratio, y: offset.y * ratio, width: screenWidth * ratio, height: screenWidth * ratio)
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else {
            return
        }
        
        fatherPicker.image = UIImage(cgImage: cgImage)
        fatherPicker.callBack()
    }
    @objc func back() {
        dismiss(animated: true)
        fatherPicker.failReason = .uncroppedImage
//        fatherPicker.callBack()
    }
    
    @objc func done() {
        dismiss(animated: true)
        fatherPicker.rootViewController.dismiss(animated: true)
        cropImage(offset: scrollView.contentOffset, ratio: imageView.image!.size.width / imageView.frame.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if imageView.image!.size.width >= imageView.image!.size.height {
            let ratio = imageView.image!.size.width / imageView.image!.size.height
            imageView.frame.size = CGSize(width: screenWidth * ratio, height: screenWidth)
        } else {
            let ratio = imageView.image!.size.height / imageView.image!.size.width
            imageView.frame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
        }

        scrollView.contentSize = imageView.frame.size
        scrollView.frame.size = CGSize(width: screenWidth, height: screenWidth)
        scrollView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)

        scrollView.contentSize = imageView.frame.size
        if imageView.frame.size.width == screenWidth {
            scrollView.contentOffset.y = (imageView.frame.size.height - screenWidth) / 2
        } else {
            scrollView.contentOffset.x = (imageView.frame.size.width - screenWidth) / 2
        }

    }
}

extension CropViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
        upperRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        lowerRectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
}


/// 画虚线框
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

/// Extension to fix orientation of an UIImage without EXIF
extension UIImage {

    func fixOrientation() -> UIImage {

        guard let cgImage = cgImage else { return self }

        if imageOrientation == .up { return self }

        var transform = CGAffineTransform.identity

        switch imageOrientation {

        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))

        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))

        case .up, .upMirrored:
            break
        }

        switch imageOrientation {

        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)

        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)

        case .up, .down, .left, .right:
            break
        }

        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {

            ctx.concatenate(transform)

            switch imageOrientation {

            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))

            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }

            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }

        // something failed -- return original
        return self
    }
}
