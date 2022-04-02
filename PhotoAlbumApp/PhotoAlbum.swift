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
}

typealias PhotoAlbums = [PhotoAlbum]
