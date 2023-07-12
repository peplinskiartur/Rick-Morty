//
//  CharacterCollectionViewModelTests.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import XCTest
import Combine
@testable import Rick_Morty

final class CharactersCollectionViewModelTests: XCTestCase {

    private var mockAppCoordinatorDelegate: MockAppCoordinatorDelegate!
    private var mockRickAndMortyService: MockRickAndMortyService!
    private var sut: CharactersCollectionViewModel!

    override func setUpWithError() throws {
        mockAppCoordinatorDelegate = MockAppCoordinatorDelegate()
        mockRickAndMortyService = MockRickAndMortyService()
        sut = CharactersCollectionViewModel(
            rickAndMortyService: mockRickAndMortyService,
            imageService: MockImageService()
        )
        sut.coordinator = mockAppCoordinatorDelegate
    }

    func test_viewModel_callViewDidLoad_getCharacters() {
        // Given
        let characters = [Character](repeating: .mock , count: 20)
        mockRickAndMortyService.result = .success((characters, isNext: false))

        // When
        sut.viewDidLoad()
        let expectation = expectation(description: "expecting loaded characters")
        let cancellable = sut.$characters
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
        XCTAssertEqual(characters, sut.characters)
    }

    func test_viewModel_callDidScrollToEnd_getNexPage() {
        // Given
        let characters = [Character](repeating: .mock , count: 20)
        mockRickAndMortyService.result = .success((characters, isNext: true))
        sut.viewDidLoad()

        // When
        sut.didScrollToTheEndOfData()
        var charactersCount = 0
        let expectation = expectation(description: "expecting loaded 2 pages of characters")
        let cancellable = sut.$characters
            .dropFirst(2)
            .collect(1)
            .first()
            .compactMap { $0.first }
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: {
                    charactersCount = $0.count
                }
            )
        waitForExpectations(timeout: 2.0)
        cancellable.cancel()

        // Then
        XCTAssertEqual(charactersCount, 40)
    }

    func test_viewModel_callDidSelectCharacter_coordinatorCalled() {
        // Given
        let characters = [Character](repeating: .mock, count: 5)
        mockRickAndMortyService.result = .success((characters, isNext: false))
        sut.viewDidLoad()

        // When
        let expectation = expectation(description: "expecting loaded characters")
        let cancellable = sut.$characters
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
        sut.didSelectCharacter(at: 0)

        // Then
        XCTAssertTrue(mockAppCoordinatorDelegate.showCharacterDetailsCalled)
    }

    func test_viewModel_noResultsState_whenNoResultsReturned() {
        // Given
        mockRickAndMortyService.result = .failure("no results")

        // When
        sut.viewDidLoad()
        let expectation = expectation(description: "expecting no results")
        let cancellable = sut.$characters
            .dropFirst()
            .collect(1)
            .flatMap { _ in self.sut.$state }
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
        XCTAssertEqual(CharactersCollectionViewModel.LoadingState.noResults, sut.state)
    }

    func test_viewModel_endOfDataState_whenNoNextPageAvailable() {
        // Given
        let characters = [Character](repeating: .mock, count: 5)
        mockRickAndMortyService.result = .success((characters, isNext: false))

        // When
        sut.viewDidLoad()
        let expectation = expectation(description: "expecting no next page")
        let cancellable = sut.$characters
            .dropFirst()
            .collect(1)
            .flatMap { _ in self.sut.$state }
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
        XCTAssertEqual(CharactersCollectionViewModel.LoadingState.endOfData, sut.state)
    }


}
