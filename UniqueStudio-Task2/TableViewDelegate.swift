//
//  TableViewDelegate.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/26.
//

import Foundation
import UIKit
import Photos

extension LibraryBrowserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var name: String?
        if indexPath.item == 0 {
            name = "所有照片"
        } else {
            name = usrCollections.object(at: indexPath.item - 1).localizedTitle
        }
       
        
        nowIndexPath = indexPath
        DispatchQueue.main.async {
            self.dropDown()
            self.btn.setTitle(name, for: .normal)
            self.refetchAssets()
            self.collectionView.reloadData()
        }

    }
}
extension LibraryBrowserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 + usrCollections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? LibraryCell else {
            fatalError()
        }
        let imageManager = PHImageManager()
        let option = PHFetchOptions()
        option.fetchLimit = 1
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        if indexPath.item == 0 {
            cell.label.text = "所有照片"
            let assets = PHAsset.fetchAssets(with: option)
            let asset = assets.object(at: 0)
            imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { img, _ in
                cell.imgView.image = img
            }
        } else {
            cell.label.text = usrCollections.object(at: indexPath.item - 1).localizedTitle
            let album = usrCollections.object(at: indexPath.item - 1) as! PHAssetCollection
            let assets = PHAsset.fetchAssets(in: album, options: option)
            let asset = assets.object(at: 0)
            imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { img, _ in
                cell.imgView.image = img
            }
            
        }
        cell.backgroundColor = tableView.backgroundColor
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
