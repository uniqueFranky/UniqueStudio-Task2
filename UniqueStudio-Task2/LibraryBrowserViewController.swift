//
//  LibraryBrowserViewController.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/11.
//

import UIKit
import Photos

class LibraryBrowserViewController: UICollectionViewController {

    var allPhotos: PHFetchResult<PHAsset>!
    var fatherPicker = ImagePicker()
    var usrCollectionPhotos: PHFetchResult<PHAsset>!
    var usrCollections: PHFetchResult<PHCollection>!
    var nowIndexPath: IndexPath!
    let tableView = UITableView()
    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: option)
        usrCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        configureBtn()
        configureTableView()
        configureCollectionView()
        configureConstraints()
//        PHPhotoLibrary.shared().register(self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: option)
        usrCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }
    func refetchAssets() {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        usrCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        if nowIndexPath == nil || nowIndexPath.item == 0 {
            allPhotos = PHAsset.fetchAssets(with: option)
        } else {
            guard let col = usrCollections.object(at: nowIndexPath.item - 1) as? PHAssetCollection else {
                fatherPicker.failReason = .invalidDir
                return
            }
            allPhotos = PHAsset.fetchAssets(in: col, options: option)
        }
    }
    func setPicker(picker: ImagePicker) {
        fatherPicker = picker
    }
    
    func configureBtn() {
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("所有照片", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(dropDown), for: .touchUpInside)
    }
    
    @objc func dropDown() {
        tableView.isHidden = !tableView.isHidden
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
    }
    
    func configureConstraints() {
        let constraints = [
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            btn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            btn.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: btn.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: btn.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ]
        view.addConstraints(constraints)
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LibraryBrowserCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: CollectionViewDelegate
extension LibraryBrowserViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = allPhotos.object(at: indexPath.item)
        let imageManager = PHImageManager()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        imageManager.requestImage(for: asset, targetSize: CGSize(width: screenWidth, height: screenHeight), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            guard let img = image else {
                self.fatherPicker.failReason = .invalidImage
                return
            }
            if img.size.height < 100 || img.size.height < 100 {
                self.fatherPicker.failReason = .invalidSize
                return
            }
            self.fatherPicker.failReason = .noError
            self.fatherPicker.image = img
        })
        dismiss(animated: true)
    }
}

//MARK: CollectionViewDataSource
extension LibraryBrowserViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        refetchAssets()
        return allPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItem", indexPath.item)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? LibraryBrowserCell else {
            fatalError()
        }
        let asset = allPhotos.object(at: indexPath.item)
        let imageManager = PHImageManager()
        let screenWidth = UIScreen.main.bounds.width
        imageManager.requestImage(for: asset, targetSize: CGSize(width: screenWidth, height: screenWidth), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
                cell.imageView.image = image
        })
        return cell
    }
    
    
}

extension LibraryBrowserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var name: String?
        if indexPath.item == 0 {
            name = "所有照片"
        } else {
            name = usrCollections.object(at: indexPath.item - 1).localizedTitle
        }
        btn.setTitle(name, for: .normal)
        tableView.isHidden = true
        nowIndexPath = indexPath
        collectionView.reloadData()
    }
}
extension LibraryBrowserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 + usrCollections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        if indexPath.item == 0 {
            cell.textLabel?.text = "所有照片"
        } else {
            cell.textLabel?.text = usrCollections.object(at: indexPath.item - 1).localizedTitle
        }
        cell.isHidden = false
        return cell
    }
}
extension LibraryBrowserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 80, height: 80)
    }
}
