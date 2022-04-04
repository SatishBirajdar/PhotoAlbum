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

}
