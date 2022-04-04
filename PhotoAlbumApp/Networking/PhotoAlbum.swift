//
//  PhotoAlbum.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import Foundation

// MARK: - AlbumModalElement
struct PhotoAlbum: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
    
    init(albumID: Int, id: Int, title: String, url: String, thumbnailURL: String){
        self.albumID = albumID
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailURL = thumbnailURL
    }
}

typealias PhotoAlbums = [PhotoAlbum]
