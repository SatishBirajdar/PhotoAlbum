//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import UIKit

class AlbumCollectionViewController: UICollectionViewController {

    // Satish also implement Network Monitor for No Internet
    
    // Check this for fetch pic for Collection View (https://www.raywenderlich.com/18895088-uicollectionview-tutorial-getting-started)
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    lazy var photoAlbumService: PhotoAlbumService = PhotoAlbumService.shared
    lazy var vm = AlbumCollectionViewModel(photoAlbumService: photoAlbumService)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.attemptToFetchViewData()
        

    }
    
    func showAlert( _ title : String, _ message : String) {
        
        var message = message
        
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
//                self.dealershipOptions = self.vm.dealershipIdOptions ?? []
//                self.locationOptions = self.vm.addressOptions ?? []
//                self.isMultiDealer = self.dealershipOptions.count > 1
//
//                if (!self.isMultiDealer && self.dealershipOptions.count == 1) {
//                    self.selectedDealershipId = self.dealershipOptions[0].id.getIntValue
//                }
//
//                self.refreshView()
            }
        }
        
        vm.getPhotoAlbums(onSuccess: { (model) in
        }, onError: {(model) in})
    }


}


class AlbumCollectionViewModel {

//    lazy var digitalRunsheetService: DigitalRunsheetService = DigitalRunsheetService.shared
    
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
    
//    private(set) var runSheetResponseModel: DigitalRunSheetModel? {
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
    func getPhotoAlbums(onSuccess : @escaping (_ : Dictionary<String, Any>) -> Void, onError : @escaping (_ : NSError) -> Void){
//        if ACVHelper.isInternetAvailable() {
            self.isLoading = true
            self.photoAlbumService.getPhotoAlbums(onSuccess: { (model) in
                    self.isLoading = false
                print(model)
            }, onError: {(model) in
            onError(model)
        })
                                                  
    }
    
    

}
