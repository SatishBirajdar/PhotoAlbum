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
    
    var monitor: NWPathMonitor = NWPathMonitor()
    var queue = DispatchQueue(label: "NetworkMonitor")
    
    var groupByUniqueAlbumId : [Int:[PhotoAlbum]] = [:]
    var albumIds : [Int] = []
    
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
    
    lazy var albums: PhotoAlbums = []
    
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
        monitor.pathUpdateHandler = {
            network in
            if network.status == .satisfied {
                DispatchQueue.main.async {
                   debugPrint("We are connected to Internet")
                }
            } else {
                DispatchQueue.main.async {
                    debugPrint("We are not connected to Internet")
                    self.error = PhotoAlbumError(title: PhotoAlbumErrorText.noInternet.typeTitleAndSubtitle.title,
                                                 message: PhotoAlbumErrorText.noInternet.typeTitleAndSubtitle.subtitle)
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func getPhotoAlbums(onSuccess : @escaping (_ : PhotoAlbums) -> Void, onError : @escaping (_ : PhotoAlbumError) -> Void){
            self.isLoading = true
            checkForInternet()
                
            self.photoAlbumService.getPhotoAlbums(onSuccess: { (model) in
                self.albums = model
                self.albumIds = self.groupByAlbumIds(albums: self.albums)
                self.didFinishFetch?()
                self.isLoading = false
                onSuccess(model)
            }, onError: {(model) in
            onError(model)
        })
    }
    
    func groupByAlbumIds(albums: PhotoAlbums) -> [Int] {
        var tempAlbumIds: [Int] = []
        self.groupByUniqueAlbumId = albums.reduce([Int:[PhotoAlbum]]()) { (res, album) -> [Int:[PhotoAlbum]] in
            var res = res
            res[album.albumID] = (res[album.albumID] ?? []) + [album]
            return res
        }
        
        for (key, _) in self.groupByUniqueAlbumId {
            tempAlbumIds.append(key)
        }
        
        return tempAlbumIds.sorted()
    }
}
