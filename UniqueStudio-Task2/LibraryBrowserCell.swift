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
    override func layoutSubviews() {
        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.borderWidth = 5.0
        self.imageView.layer.borderColor = UIColor.clear.cgColor
        self.imageView.layer.masksToBounds = true
        
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
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
