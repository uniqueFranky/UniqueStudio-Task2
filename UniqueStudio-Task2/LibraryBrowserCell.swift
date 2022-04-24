//
//  LibraryBrowserCell.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/12.
//

import UIKit

class LibraryBrowserCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
//    override func layoutSubviews() {
//        // cell rounded section
//        self.layer.cornerRadius = 15.0
//        self.layer.borderWidth = 5.0
//        self.layer.borderColor = UIColor.clear.cgColor
//        self.layer.masksToBounds = true
//        clipsToBounds = true
//        // cell shadow section
//        self.contentView.layer.cornerRadius = 15.0
//        self.contentView.layer.borderWidth = 5.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
//        self.contentView.layer.masksToBounds = true
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
//        self.layer.shadowRadius = 6.0
//        self.layer.shadowOpacity = 0.6
//        self.layer.cornerRadius = 15.0
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
//    }
    let imageView = UIImageView()
    func configureImageView() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        addConstraints(constraints)
    }
}
