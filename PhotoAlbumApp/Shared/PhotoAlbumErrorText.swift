//
//  PhotoAlbumError.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-05.
//

import Foundation

enum PhotoAlbumErrorText {
    case noInternet
    case serverSideFailure
    case objectNotFound

    var typeTitleAndSubtitle: (title: String, subtitle: String) {
       switch self {
       case .noInternet:
            return ("No Internet Connection", "Please check your internet and try again.")
       case .serverSideFailure:
           return ("Failure", "Found issues while fetching Photo Albums, please try again later.")
       case .objectNotFound:
           return ("Failure", "Object not found.")
       }
    }
}
