//
//  FIlterViewModelTests.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 12/07/2023.
//

import XCTest
import Combine
@testable import Rick_Morty

final class FIlterViewModelTests: XCTestCase {

    private var mockSearchText: String? = nil
    private var sut: FilterViewModel!

    override func setUpWithError() throws {
        mockSearchText = nil
        sut = FilterViewModel(searchText: mockSearchText)
    }

    func test_viewModel_clearedSearchText_onClearPressed() {
        // Given
        mockSearchText = "test_text"

        // When
        let expectation = expectation(description: "expecting clear event published")
        let cancellable = sut.didClearPublisher
            .eraseToAnyPublisher()
            .collect(1)
            .first()
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
        sut.didPressClearButton()
        waitForExpectations(timeout: 2.0)
        cancellable.cancel()

        // Then
        XCTAssertNil(sut.searchText)
    }

    func test_viewModel_updatesSearchText_onProceedPressed() {
        // Given
        mockSearchText = "test_text"

        // When
        sut.didEnterSearchText("test_text_2")
        let expectation = expectation(description: "expecting filter event published")
        let cancellable = sut.didFilterPublisher
            .eraseToAnyPublisher()
            .collect(1)
            .first()
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
        sut.didPressProceedButton()
        waitForExpectations(timeout: 2.0)
        cancellable.cancel()

        // Then
        XCTAssertNotEqual(mockSearchText, sut.searchText)
    }
}
