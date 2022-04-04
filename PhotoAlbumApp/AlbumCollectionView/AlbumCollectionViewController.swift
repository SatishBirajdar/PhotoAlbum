//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import UIKit
import Network

class AlbumCollectionViewController: UIViewController {
    
    let reuseIdentifier = "PhotoAlbumCellIdentifer";
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var albumCollectionView: UICollectionView!
    @IBOutlet var errorView: ErrorView!
    lazy var photoAlbumService: PhotoAlbumService = PhotoAlbumService.shared
    lazy var vm = AlbumCollectionViewModel(photoAlbumService: photoAlbumService)
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resetErrorView()
        self.attemptToFetchViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func startLoadingSpinner() {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    func stopLoadingSpinner() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
    }
    
    private func attemptToFetchViewData() {
        vm.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            let _ = self.vm.isLoading ? self.startLoadingSpinner() : self.stopLoadingSpinner()
        }
        
        vm.showAlertClosure = { [weak self] in
            if let error = self?.vm.error {
                DispatchQueue.main.async {
                    self?.errorView.isHidden = false
                    self?.errorView.titleLabel.text = error.title
                    self?.errorView.messageLabel.text = error.message
                }
            }
        }
        
        vm.didFinishFetch = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.albumCollectionView.reloadData()
            }
        }
        
        vm.getPhotoAlbums(onSuccess: { (model) in
        }, onError: {(model) in})
    }
    
    func resetErrorView(){
        self.errorView.isHidden = true
        self.errorView.titleLabel.text = ""
        self.errorView.messageLabel.text = ""
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension AlbumCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.albumIds.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoAlbumCollectionViewCell
        
        let photosOfAlbum = self.vm.groupByUniqueAlbumId[self.vm.albumIds[indexPath.row]]
        guard let firstPhotoOfAlbum = photosOfAlbum?[0] else { return cell }
        cell.configure(urlString: firstPhotoOfAlbum.thumbnailURL, name: "Album \(String(self.vm.albumIds[indexPath.row]))")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PhotosCollectionViewController") as? PhotosCollectionViewController
        vc?.tle = String(self.vm.albumIds[indexPath.row])
        vc?.photos = self.vm.groupByUniqueAlbumId[self.vm.albumIds[indexPath.row]] ?? []
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AlbumCollectionViewController: UICollectionViewDelegateFlowLayout {

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
