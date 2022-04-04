//
//  PhotosCollectionViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-04.
//


import UIKit
import Kingfisher



class PhotosCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // Satish also implement Network Monitor for No Internet
    
    // Check this for fetch pic for Collection View (https://www.raywenderlich.com/18895088-uicollectionview-tutorial-getting-started)
    
    
    
    let reuseIdentifier = "PhotoAlbumCellIdentifer";
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    
    var tle: String = ""
    var photos: [PhotoAlbum] = []
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    
//    lazy var photoAlbumService: PhotoAlbumService = PhotoAlbumService.shared
//    lazy var vm = AlbumCollectionViewModel(photoAlbumService: photoAlbumService)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.attemptToFetchViewData()
        
        self.title = "Album \(String(describing: tle))"
        
        loadingIndicator.isHidden = true
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
        return photos.count
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoAlbumCollectionViewCell
        
//        let photosOfAlbum = self.vm.groupByUniqueAlbumId[self.vm.uniqueKeys[indexPath.row]]
//
//        guard let firstPhotoOfAlbum = photosOfAlbum?[0] else { return cell }
        
        let url = URL(string: photos[indexPath.row].thumbnailURL)
        if let url = url {
            cell.thumnailImageView.kf.setImage(with: url)
        }
        cell.albumIdLabel.text = "Track \(String(photos[indexPath.row].id))"
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let noOfCellsInRow = 2   //number of column you want
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//        return CGSize(width: size, height: size)
//    }
    
//    func collectionView(_ collectionView1: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
//        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
//        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
//        return CGSize(width: size, height: size)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             //Do your logic here
        
//        let photosOfAlbum = self.vm.groupByUniqueAlbumId[self.vm.uniqueKeys[indexPath.row]]
        
        print("Satish clicked \(self.photos[indexPath.row])")

    }
    
    
        
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
