//
//  AlbumCollectionViewModel.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-04.
//

import Foundation
import Network

class AlbumCollectionViewModel {
    var photoAlbumService: PhotoAlbumServiceClient
    
    var mon: NWPathMonitor = NWPathMonitor()
    var queue = DispatchQueue(label: "Monitor")
    
    var groupByUniqueAlbumId : [Int:[PhotoAlbum]] = [:]
    var uniqueKeys : [Int] = []
    
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var error : PhotoAlbumError? {
        didSet {
            self.showAlertClosure?()
            self.isLoading = false
        }
    }
    
    lazy var photoAlbums: PhotoAlbums = []
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    init(photoAlbumService: PhotoAlbumServiceClient = PhotoAlbumService.shared){
        self.photoAlbumService = photoAlbumService
    }
}

extension AlbumCollectionViewModel {
    
    func checkForInternet(){
        mon.pathUpdateHandler = {
            p in
            if p.status == .satisfied {
                DispatchQueue.main.async {
                   debugPrint("We are connected to Internet")
                }
            } else {
                DispatchQueue.main.async {
                    debugPrint("We are not connected to Internet")
                    self.error = PhotoAlbumError(title: "No Internet Connection", message: "Please check your internet and try again.")
//                    self.showAlert("No Internet Connection", "Please check your internet and try again.")
                }
            }
        }
        mon.start(queue: queue)
    }
    
    func getPhotoAlbums(onSuccess : @escaping (_ : PhotoAlbums) -> Void, onError : @escaping (_ : PhotoAlbumError) -> Void){
//        if ACVHelper.isInternetAvailable() {
            self.isLoading = true
        
            checkForInternet()
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
