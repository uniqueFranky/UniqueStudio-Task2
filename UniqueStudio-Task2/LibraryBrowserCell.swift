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
