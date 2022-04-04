//
//  PhotoAlbumError.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-05.
//

import Foundation

enum PhotoAlbumErrorText {
    case noInternet

    var typeTitleAndSubtitle: (title: String, subtitle: String) {
       switch self {
       case .noInternet:
            return ("No Internet Connection", "Please check your internet and try again.")
       }
    }
}
