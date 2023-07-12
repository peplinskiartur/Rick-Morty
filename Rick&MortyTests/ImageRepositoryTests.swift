//
//  Rick_MortyTests.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 05/07/2023.
//

import XCTest
@testable import Rick_Morty

final class ImageRepositoryTests: XCTestCase {

    private var sut: ImageRepository!

    override func setUpWithError() throws {
        sut = ImageRepository()
    }

    func test_repositoryStoresValue() {
        // Given
        let image = #imageLiteral(resourceName: "No_image_found")
        let imageKey = "test_image"

        // When
        sut.set(image, for: imageKey)

        // Then
        XCTAssertEqual(image, sut.get(imageKey))
    }

    func test_repositoryDoesntContainValueIfNotStoredPreviously() {
        // Given
        let notExistingImageKey = "test_image"

        // When
        let notExistingImage = sut.get(notExistingImageKey)

        // Then
        XCTAssertNil(notExistingImage)
    }
}
