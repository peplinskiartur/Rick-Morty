//
//  CharacterDetailsViewModelTests.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import XCTest
@testable import Rick_Morty

final class CharacterDetailsViewModelTests: XCTestCase {

    private var mockAppCoordinatorDelegate: MockAppCoordinatorDelegate!
    private var mockImageService: MockImageService!
    private var sut: CharacterDetailsViewModel!

    override func setUpWithError() throws {
        mockAppCoordinatorDelegate = MockAppCoordinatorDelegate()
        mockImageService = MockImageService()
        sut = CharacterDetailsViewModel(
            imageService: mockImageService,
            character: .mock
        )
        sut.coordinator = mockAppCoordinatorDelegate
    }

    func test_viewModel_callViewDidLoad() {
        // Given
        let image = UIImage(named: "No_image_found")!
        mockImageService.result = .success(image)

        // When
        sut.viewDidLoad()
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

    func test_viewModel_callDidScrollToDismiss_coordinatorCalled() {
        // Given

        // When
        sut.didScrollToDismiss()

        // Then
        XCTAssertTrue(mockAppCoordinatorDelegate.dismissCharacterDetailsCalled)
    }
}
