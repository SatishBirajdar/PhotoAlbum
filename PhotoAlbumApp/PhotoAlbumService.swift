//
//  AlbumService.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import Foundation

protocol PhotoAlbumServiceClient {
    func getPhotoAlbums(onSuccess: @escaping (PhotoAlbums) -> Void, onError : @escaping (PhotoAlbumError) -> Void)
}

final class PhotoAlbumService {
    static let shared = PhotoAlbumService()
    lazy var api: PhotoAlbumAPI = PhotoAlbumAPI.shared
}

extension PhotoAlbumService: PhotoAlbumServiceClient {
    public func getPhotoAlbums(onSuccess: @escaping (PhotoAlbums) -> Void, onError : @escaping (PhotoAlbumError) -> Void) {
        api.Get(path: "photos", params: [:], onSuccess: { (model) in
            onSuccess(model)
        }) { (model) in
            onError(model)
        }
    }
}
