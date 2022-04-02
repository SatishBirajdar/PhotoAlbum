//
//  ViewController.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import UIKit

class AlbumCollectionViewController: UICollectionViewController {

    // Satish also implement Network Monitor for No Internet
    
    lazy var photoAlbumService: PhotoAlbumService = PhotoAlbumService.shared
    lazy var vm = AlbumCollectionViewModel(photoAlbumService: photoAlbumService)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        vm.getPhotoAlbums(onSuccess: { (model) in
        }, onError: {(model) in})
    }


}


class AlbumCollectionViewModel {

//    lazy var digitalRunsheetService: DigitalRunsheetService = DigitalRunsheetService.shared
    
    var photoAlbumService: PhotoAlbumServiceClient
    
    init(photoAlbumService: PhotoAlbumServiceClient = PhotoAlbumService.shared){
        self.photoAlbumService = photoAlbumService
    }


}


extension AlbumCollectionViewModel {
    func getPhotoAlbums(onSuccess : @escaping (_ : Dictionary<String, Any>) -> Void, onError : @escaping (_ : NSError) -> Void){
//        if ACVHelper.isInternetAvailable() {
//            self.isLoading = true
            self.photoAlbumService.getPhotoAlbums(onSuccess: { (model) in
//                    self.isLoading = false
                print(model)
            }, onError: {(model) in
            onError(model)
        })
                                                  
    }
}
