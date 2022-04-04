//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import UIKit
import Network

class AlbumCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // Satish also implement Network Monitor for No Internet
    
    // Check this for fetch pic for Collection View (https://www.raywenderlich.com/18895088-uicollectionview-tutorial-getting-started)
    
    let reuseIdentifier = "PhotoAlbumCellIdentifer";
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    lazy var photoAlbumService: PhotoAlbumService = PhotoAlbumService.shared
    lazy var vm = AlbumCollectionViewModel(photoAlbumService: photoAlbumService)
    
//    var mon: NWPathMonitor = NWPathMonitor()
//    var queue = DispatchQueue(label: "Monitor")
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        mon.pathUpdateHandler = {
//            p in
//            if p.status == .satisfied {
//                DispatchQueue.main.async {
//                   debugPrint("We are connected to Internet")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    debugPrint("We are not connected to Internet")
//                    self.showAlert("No Internet Connection", "Please check your internet and try again.")
//                }
//            }
//        }
//        mon.start(queue: queue)
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
        return vm.uniqueKeys.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoAlbumCollectionViewCell
        
        let photosOfAlbum = self.vm.groupByUniqueAlbumId[self.vm.uniqueKeys[indexPath.row]]
        
        guard let firstPhotoOfAlbum = photosOfAlbum?[0] else { return cell }

        cell.configure(urlString: firstPhotoOfAlbum.thumbnailURL, name: "Album \(String(self.vm.uniqueKeys[indexPath.row]))")
        
        return cell
    }
    
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
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

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
                    self?.showAlert(error.title, error.message)
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
