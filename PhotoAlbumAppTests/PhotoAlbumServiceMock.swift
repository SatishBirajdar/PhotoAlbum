//
//  PhotoAlbumServiceMock.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-04.
//

import Foundation

class PhotoAlbumServiceMock : PhotoAlbumServiceClient {
    var getPhotoAlbumsCallCount = 0
    
    func getPhotoAlbums(onSuccess: @escaping (PhotoAlbums) -> Void, onError : @escaping (PhotoAlbumError) -> Void) {
        getPhotoAlbumsCallCount += 1
    }
}
