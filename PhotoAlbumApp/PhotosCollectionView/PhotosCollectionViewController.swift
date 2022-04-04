//
//  PhotosCollectionViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-04.
//


import UIKit
import Kingfisher

class PhotosCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let reuseIdentifier = "PhotoAlbumCellIdentifer";
    
    @IBOutlet var photosCollectionView: UICollectionView!
    
    var tle: String = ""
    var photos: [PhotoAlbum] = []
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Album \(String(describing: tle))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //UICollectionViewDatasource methods
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
     }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoAlbumCollectionViewCell
        cell.configure(urlString: photos[indexPath.row].thumbnailURL, name: "Track \(String(photos[indexPath.row].id))")
        return cell
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
