//
//  MockRickAndMortyPageResponse.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import Foundation
@testable import Rick_Morty

extension RickAndMortyPageResponse where T == [Character] {
    static func mock(characters: [Character] = [Character](repeating: .mock, count: 5)) -> RickAndMortyPageResponse {
        RickAndMortyPageResponse(
            info: .init(count: characters.count, pages: 1, nextURL: nil, prevURL: nil),
            results: characters
        )
    }
}
