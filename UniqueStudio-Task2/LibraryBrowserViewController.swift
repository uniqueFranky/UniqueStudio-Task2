//
//  LibraryBrowserViewController.swift
//  UniqueStudio-Task2
//
//  Created by 闫润邦 on 2022/4/11.
//

import UIKit
import Photos
import PhotosUI

class LibraryBrowserViewController: UICollectionViewController {

    var allPhotos: PHFetchResult<PHAsset>!
    var fatherPicker = ImagePicker()
    var usrCollectionPhotos: PHFetchResult<PHAsset>!
    var usrCollections: PHFetchResult<PHCollection>!
    var nowIndexPath: IndexPath!
    var tableViewBottomConstraint: NSLayoutConstraint!
    var isTableHidden: Bool!
    var authStatus: PHAuthorizationStatus! {
        didSet {
            if authStatus == .authorized {
                hideAuthBtn()
            } else {
                showAuthBtn()
            }
            refetchAssets()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    let tableView = UITableView()
    let btn = UIButton()
    let authBtn = UIButton()
    let cancelBtn = UIButton()
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor)
        view.backgroundColor = .lightGray
        PHPhotoLibrary.shared().register(self)
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: option)
        usrCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        configureAuthBtn()
        configureBtn()
        configureCancelBtn()
        configureTableView()
        configureCollectionView()
        configureConstraints()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Browser View will Appear")
        authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        refetchAssets()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        
        if fatherPicker.authStatus == .limited {
            authBtn.isHidden = false
            cancelBtn.isHidden = false
        }
    }
    
    
    @objc func back() {
        dismiss(animated: true)
        fatherPicker.failReason = .userCancelled
        fatherPicker.callBack()
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
    func configureAuthBtn() {
        view.addSubview(authBtn)
        authBtn.translatesAutoresizingMaskIntoConstraints = false
        authBtn.setTitle("相册访问被限制，点击选择更多照片，或转到设置更新权限", for: .normal)
        authBtn.setTitleColor(.black, for: .normal)
        authBtn.titleLabel?.lineBreakMode = .byCharWrapping
        authBtn.addTarget(self, action: #selector(requestAuth), for: .touchUpInside)
    }
    func configureBtn() {
        navigationItem.titleView = btn
        btn.semanticContentAttribute = .forceRightToLeft
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("所有照片", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setImage(UIImage(systemName: "arrow.right.circle"), for: .normal)
        btn.addTarget(self, action: #selector(dropDown), for: .touchUpInside)
        btn.tintColor = .black
    }
    func configureCancelBtn() {
        view.addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(hideAuthBtn), for: .touchUpInside)
    }
    
    @objc func dropDown() {
        isTableHidden = !isTableHidden
        UIView.animate(withDuration: 0.3) {
            if let imageView = self.btn.imageView {
                imageView.transform = imageView.transform.rotated(by: self.isTableHidden ? -.pi / 2 : .pi / 2)
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear]) {
            self.tableViewBottomConstraint.isActive = false
            
            if self.isTableHidden {
                
                self.tableViewBottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.tableView.topAnchor)
            } else {
                
                self.tableViewBottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.main.bounds.height / 5)
            }
            
            self.tableViewBottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func requestAuth() {
        
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self) { identifiers in
            self.refetchAssets()
            self.collectionView.reloadData()
        }
        
    }
    @objc func hideAuthBtn() {
        DispatchQueue.main.async {
            self.authBtn.isHidden = true
            self.cancelBtn.isHidden = true
        }

    }
    func showAuthBtn() {
        DispatchQueue.main.async {
            self.authBtn.isHidden = false
            self.cancelBtn.isHidden = false
        }

    }
    func configureTableView() {
        view.addSubview(tableView)
        isTableHidden = true
        tableView.backgroundColor = .darkGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LibraryCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 20
        tableView.rowHeight = 60
        
//        tableView.isHidden = true
    }
    
    func configureConstraints() {
        let constraints = [
//            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            btn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            btn.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            authBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            authBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 4 / 5),
            authBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -50),
            authBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            cancelBtn.leadingAnchor.constraint(equalTo: authBtn.trailingAnchor),
            cancelBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cancelBtn.topAnchor.constraint(equalTo: authBtn.topAnchor),
            cancelBtn.bottomAnchor.constraint(equalTo: authBtn.bottomAnchor),
        ]
        view.addConstraints(constraints)
        tableViewBottomConstraint.isActive = true
    }
    
    func configureCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.backgroundColor = view.backgroundColor
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

extension LibraryBrowserViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("DidChange!")
        refetchAssets()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            hideAuthBtn()
        } else {
            showAuthBtn()
        }
    }
}
