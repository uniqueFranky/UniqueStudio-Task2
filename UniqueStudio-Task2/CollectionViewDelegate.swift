//
//  CollectionViewDelegate&DataSource.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/26.
//

import Foundation
import UIKit
import Photos

//MARK: CollectionViewDelegate
extension LibraryBrowserViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = allPhotos.object(at: indexPath.item)
        let imageManager = PHImageManager()
        let opts = PHImageRequestOptions()
        opts.deliveryMode = .highQualityFormat
        opts.isSynchronous = true
        opts.isNetworkAccessAllowed = true
        opts.resizeMode = .exact
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: opts, resultHandler: { image, _ in
            guard let img = image else {
                self.fatherPicker.failReason = .invalidImage
                self.fatherPicker.callBack()
                return
            }
            if self.fatherPicker.isValid(img) == false {
                self.fatherPicker.failReason = .invalidSize
                self.fatherPicker.callBack()
                return
            }
            self.fatherPicker.failReason = .noError
            self.fatherPicker.image = img
            let cvc = CropViewController()
            cvc.setupImageView(image: self.fatherPicker.image)
            cvc.setPicker(self.fatherPicker)
            let navi = UINavigationController(rootViewController: cvc)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        })

    }
}

//MARK: CollectionViewDataSource
extension LibraryBrowserViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        refetchAssets()
        return allPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? LibraryBrowserCell else {
            fatalError()
        }
        let asset = allPhotos.object(at: indexPath.item)
        let imageManager = PHImageManager()
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
                cell.imageView.image = image
        })
        return cell
    }
}

extension LibraryBrowserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 4 - 10, height: UIScreen.main.bounds.width / 4 - 10)
    }
}
