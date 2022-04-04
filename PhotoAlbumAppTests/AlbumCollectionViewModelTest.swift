//
//  AlbumCollectionViewModelTest.swift
//  PhotoAlbumAppTests
//
//  Created by satishbirajdar on 2022-04-04.
//

import XCTest
@testable import PhotoAlbumApp

class AlbumCollectionViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        
    func test_GetCreate() {
        // Given
        let mockClient = PhotoAlbumServiceMock()
        
        let vm = AlbumCollectionViewModel(photoAlbumService: mockClient)

        // When
        vm.getPhotoAlbums(onSuccess: { (model) in
        }, onError: {(model) in})
        
        // Then
        XCTAssert(mockClient.getPhotoAlbumsCallCount == 1)
    }
    
    func test_getPhotoAlbums(){
        // Given
        let mockClient = PhotoAlbumServiceMock()
        let vm = AlbumCollectionViewModel(photoAlbumService: mockClient)
        
        // When
        let albums = [PhotoAlbum(albumID: 1, id: 1, title: "accusamus beatae ad facilis cum similique qui sunt", url: "https://via.placeholder.com/600/92c952", thumbnailURL: "https://via.placeholder.com/150/92c952"), PhotoAlbum(albumID: 1, id: 2, title: "reprehenderit est deserunt velit ipsam", url: "https://via.placeholder.com/600/771796", thumbnailURL:  "https://via.placeholder.com/150/771796"), PhotoAlbum(albumID: 3, id: 3, title: "officia porro iure quia iusto qui ipsa ut modi", url: "https://via.placeholder.com/600/24f355", thumbnailURL: "https://via.placeholder.com/150/24f355"), PhotoAlbum(albumID: 2, id: 4, title: "officia porro iure quia iusto qui ipsa ut modi", url: "https://via.placeholder.com/600/24f355", thumbnailURL: "https://via.placeholder.com/150/24f355")]
        
        // Then
        XCTAssert(vm.groupByAlbumIds(albums: albums) == [1, 2, 3])
    }

}
