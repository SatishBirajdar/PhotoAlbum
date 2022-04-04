//
//  PhotoAlbumAPI.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-02.
//

import Foundation

class PhotoAlbumAPI {
    
    static let shared = PhotoAlbumAPI()
    
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    
    private init() {}
    
    public func Get(path: String, params: Dictionary<String,Any> = [:], onSuccess : @escaping (_ : PhotoAlbums) -> Void, onError : @escaping (_ : PhotoAlbumError) -> Void)
    {
        let query : String = baseURL.appending(path)
        if let url = URL(string: query) {
            var request = URLRequest(url: url)
            request.timeoutInterval = TimeInterval(120)
            
            urlSession.dataTask(with: request) { (data, response, error) in
                self.handleResponse(route: path, data: data, response: response, error: error, onSuccess: onSuccess, onError: onError)
                }.resume()
        }
    }
    
    private func handleResponse(route: String, data: Data?, response: URLResponse?, error : Error?, onSuccess : (_ : PhotoAlbums) -> Void, onError : (_ : PhotoAlbumError) -> Void) -> Void {
        if let _ = error {
            onError(PhotoAlbumError(title: PhotoAlbumErrorText.serverSideFailure.typeTitleAndSubtitle.title, message: PhotoAlbumErrorText.serverSideFailure.typeTitleAndSubtitle.subtitle))
        }

        guard let data = data else {
            return onError(PhotoAlbumError(title: PhotoAlbumErrorText.objectNotFound.typeTitleAndSubtitle.title, message: PhotoAlbumErrorText.objectNotFound.typeTitleAndSubtitle.subtitle))
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let responseModel = try decoder.decode(PhotoAlbums.self, from:data) //Decode JSON Response Data
            
            onSuccess(responseModel)
        } catch let parsingError {
            debugPrint("Failed to convert data\(parsingError)")
            onError(PhotoAlbumError(title: PhotoAlbumErrorText.objectNotFound.typeTitleAndSubtitle.title, message: PhotoAlbumErrorText.objectNotFound.typeTitleAndSubtitle.subtitle))
        }
    }
}

protocol URLSessionProtocol: AnyObject {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
