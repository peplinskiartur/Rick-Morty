//
//  CharacterImageViewModelTests.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import XCTest
@testable import Rick_Morty

final class CharacterImageViewModelTests: XCTestCase {

    private var mockImageService: MockImageService!
    private var sut: CharacterImageViewModel!

    override func setUpWithError() throws {
        mockImageService = MockImageService()
        sut = CharacterImageViewModel(
            imageService: mockImageService,
            character: .mock
        )
    }

    func test_viewModel_callWillDisplayCell() {
        // Given
        let image = UIImage(named: "No_image_found")!
        mockImageService.result = .success(image)

        // When
        sut.willDisplayCell()
        let expectation = expectation(description: "expecting loaded image")
        let cancellable = sut.$image
            .dropFirst()
            .collect(1)
            .first()
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
        waitForExpectations(timeout: 2.0)
        cancellable.cancel()

        // Then
        XCTAssertEqual(image, sut.image)
    }

    func test_viewModel_callPrepareForReuse() {
        // Given

        // When
        sut.willDisplayCell()
        sut.prepareForReuse()

        // Then
        XCTAssertNil(sut.image)
    }
}
