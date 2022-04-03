//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import UIKit

class AlbumCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Satish also implement Network Monitor for No Internet
    
    // Check this for fetch pic for Collection View (https://www.raywenderlich.com/18895088-uicollectionview-tutorial-getting-started)
    
    let reuseIdentifier = "PhotoAlbumCellIdentifer";
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    lazy var photoAlbumService: PhotoAlbumService = PhotoAlbumService.shared
    lazy var vm = AlbumCollectionViewModel(photoAlbumService: photoAlbumService)
    
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
     {
         return 4;
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
     {
         return 1;
     }
     
     //UICollectionViewDatasource methods
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
     }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.photoAlbums.count
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoAlbumCollectionViewCell
        let url = URL(string: self.vm.photoAlbums[indexPath.row].thumbnailURL)
        if let url = url {
            cell.thumnailImageView.load(url: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
     // custom function to generate a random UIColor
     func randomColor() -> UIColor{
         let red = CGFloat(drand48())
         let green = CGFloat(drand48())
         let blue = CGFloat(drand48())
         return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
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
                    self.isLoading = false
                self.photoAlbums = model
                print(model)
                self.didFinishFetch?()
                onSuccess(model)
            }, onError: {(model) in
            onError(model)
        })
    }
}
