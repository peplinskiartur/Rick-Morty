//
//  RickAndMortyServiceTests.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import XCTest
@testable import Rick_Morty

final class RickAndMortyServiceTests: XCTestCase {

    private var mockAPIClient: MockAPIClient!
    private var sut: RickAndMortyService!

    override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        sut = RickAndMortyService(
            apiClient: mockAPIClient
        )
    }

    func test_service_getCharacters_success() async throws {
        // Given
        let characters = [Character](repeating: .mock, count: 5)
        mockAPIClient.result = .success(RickAndMortyPageResponse<[Character]>.mock(characters: characters))

        // When
        let (loadedCharacters, _) = try await sut.getCharacters()

        // Then
        XCTAssertEqual(characters, loadedCharacters)
    }
}
