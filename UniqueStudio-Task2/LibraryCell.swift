//
//  LibraryCell.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/26.
//

import UIKit

class LibraryCell: UITableViewCell {
    let label = UILabel()
    let imgView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        configureImageView()
        configureLabel()
        clipsToBounds = true
    }
    
    func configureImageView() {
        addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        let constraints = [
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imgView.topAnchor.constraint(equalTo: topAnchor),
            imgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
        ]
        addConstraints(constraints)
    }
    
    func configureLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            label.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: imgView.topAnchor),
            label.bottomAnchor.constraint(equalTo: imgView.bottomAnchor),
        ]
        addConstraints(constraints)
    }
}
