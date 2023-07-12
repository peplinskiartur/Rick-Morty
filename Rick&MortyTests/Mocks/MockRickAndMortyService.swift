//
//  MockRickAndMortyService.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import Foundation
@testable import Rick_Morty

final class MockRickAndMortyService: RickAndMortyServiceProtocol {
    typealias ServiceResult = ([Rick_Morty.Character], isNext: Bool)
    var result: Result<ServiceResult, Error> = .failure("no results")

    func getCharacters(page: Int) async throws -> ServiceResult {
        try result.get()
    }

    func getCharacters(name: String?, status: Rick_Morty.Character.Status?, gender: Rick_Morty.Character.Gender?, page: Int) async throws -> ServiceResult {
        try result.get()
    }
}
