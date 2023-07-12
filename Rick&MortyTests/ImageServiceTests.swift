//
//  ImageServiceTests.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import XCTest
@testable import Rick_Morty

final class ImageServiceTests: XCTestCase {

    private var mockRemoteImageProvider: MockRemoteImageProvider!
    private var mockImageRepository: MockImageRepository!
    private var sut: ImageService!

    override func setUpWithError() throws {
        mockRemoteImageProvider = MockRemoteImageProvider()
        mockImageRepository = MockImageRepository()
        sut = ImageService(
            remoteImageProvider: mockRemoteImageProvider,
            imageRepository: mockImageRepository
        )
    }

    func test_imageService_loadImage_remote_success() async throws {
        // Given
        let imageURLString = "urlToImage"
        let image = UIImage(named: "No_image_found")!
        let data = image.pngData()!
        mockRemoteImageProvider.result = .success(data)

        // When
        let loadedImage = await sut.loadImage(imageURLString)

        // Then
        XCTAssertEqual(data, loadedImage.pngData()!)
    }

    func test_imageService_loadImage_remote_failure() async throws {
        // Given
        let imageURLString = "urlToImage"
        let fallbackImage = UIImage(named: "No_image_found")!
        mockRemoteImageProvider.result = .failure("no image available")

        // When
        let loadedImage = await sut.loadImage(imageURLString)

        // Then
        XCTAssertEqual(fallbackImage, loadedImage)
    }

    func test_imageService_loadImage_cache_success() async {
        // Given
        let imageURLString = "urlToImage"
        let cachedImage = UIImage(systemName: "trash")!

        mockImageRepository.set(cachedImage, for: imageURLString)

        // When
        let loadedImage = await sut.loadImage(imageURLString)

        // Then
        XCTAssertEqual(cachedImage, loadedImage)
    }
}
