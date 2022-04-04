//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import UIKit
import Kingfisher

class AlbumCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // Satish also implement Network Monitor for No Internet
    
    // Check this for fetch pic for Collection View (https://www.raywenderlich.com/18895088-uicollectionview-tutorial-getting-started)
    
    let reuseIdentifier = "PhotoAlbumCellIdentifer";
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
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
        
        self.attemptToFetchViewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UICollectionViewDelegateFlowLayout methods
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//     {
//         return 4;
//     }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//     {
//         return 1;
//     }
     
     //UICollectionViewDatasource methods
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
     }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.uniqueKeys.count
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoAlbumCollectionViewCell
        
        let photosOfAlbum = self.vm.groupByUniqueAlbumId[self.vm.uniqueKeys[indexPath.row]]
        
        guard let firstPhotoOfAlbum = photosOfAlbum?[0] else { return cell }
        
        let url = URL(string: firstPhotoOfAlbum.thumbnailURL)
        if let url = url {
            cell.thumnailImageView.kf.setImage(with: url)
        }
        cell.albumIdLabel.text = "Album \(String(self.vm.uniqueKeys[indexPath.row]))"
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
//    func collectionView(_ collectionView1: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
//        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
//        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
//        return CGSize(width: size, height: size)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             //Do your logic here
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PhotosCollectionViewController") as? PhotosCollectionViewController
        
        
        vc?.tle = String(self.vm.uniqueKeys[indexPath.row])
        vc?.photos = self.vm.groupByUniqueAlbumId[self.vm.uniqueKeys[indexPath.row]] ?? []
        
        print("Satish clicked \(self.vm.uniqueKeys[indexPath.row])")
        
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    
    func showAlert( _ title : String, _ message : String) {
        
//        var message = message
        
//        if message.isEmpty {
//            if(!ACVHelper.isInternetAvailable()) {
//                message = "Please connect to the internet!"
//            }
//        }
        
        if !message.isEmpty {
            // create the alert
            let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
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
//                print("Error: \(error.message)")
                DispatchQueue.main.async {
                    self?.showAlert("Title", error.localizedDescription)
                }
            }
        }
        
        vm.didFinishFetch = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        }
        
        vm.getPhotoAlbums(onSuccess: { (model) in
            print(model)
        }, onError: {(model) in})
    }
}

class AlbumCollectionViewModel {
    var photoAlbumService: PhotoAlbumServiceClient
    
    var groupByUniqueAlbumId : [Int:[PhotoAlbum]] = [:]
    var uniqueKeys : [Int] = []
    
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var error : NSError? {
        didSet {
            self.showAlertClosure?()
            self.isLoading = false
        }
    }
    
    lazy var photoAlbums: PhotoAlbums = []
    
//    private(set) var photoAlbums: PhotoAlbums? {
//        get {
//            digitalRunsheetService.latestRunSheetResponseModel
//        }
//        set {
//            digitalRunsheetService.latestRunSheetResponseModel = newValue
//        }
//    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    init(photoAlbumService: PhotoAlbumServiceClient = PhotoAlbumService.shared){
        self.photoAlbumService = photoAlbumService
    }
}

extension AlbumCollectionViewModel {
    func getPhotoAlbums(onSuccess : @escaping (_ : PhotoAlbums) -> Void, onError : @escaping (_ : NSError) -> Void){
//        if ACVHelper.isInternetAvailable() {
            self.isLoading = true
            self.photoAlbumService.getPhotoAlbums(onSuccess: { (model) in
                self.photoAlbums = model
                print(model)
                
                self.groupByUniqueAlbumId = self.photoAlbums.reduce([Int:[PhotoAlbum]]()) { (res, album) -> [Int:[PhotoAlbum]] in
                    var res = res
                    res[album.albumID] = (res[album.albumID] ?? []) + [album]
                    return res
                }
                
                print(self.groupByUniqueAlbumId)
                
                for (key, value) in self.groupByUniqueAlbumId {
                    self.uniqueKeys.append(key)
                }
                self.uniqueKeys.sort()
                
                self.didFinishFetch?()
                self.isLoading = false
                onSuccess(model)
            }, onError: {(model) in
            onError(model)
        })
    }
}


extension AlbumCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
