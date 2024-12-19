//
//  RickAndMortyService.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import Foundation

protocol RickAndMortyServiceProtocol {
    func getCharacters(page: Int) async throws -> ([Character], isNext: Bool)
    func getCharacters(name: String?, status: Character.Status?, gender: Character.Gender?, page: Int) async throws -> ([Character], isNext: Bool)
}

class RickAndMortyService: RickAndMortyServiceProtocol {

    private let baseURLString: String = "rickandmortyapi.com"

    private enum Endpoints: String {
        case character = "/api/character"
    }

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getCharacters(page: Int = 0) async throws -> ([Character], isNext: Bool) {
        try await getCharacters(
            name: nil,
            status: nil,
            gender: nil,
            page: page
        )
    }

    func getCharacters(
        name: String? = nil,
        status: Character.Status? = nil,
        gender: Character.Gender? = nil,
        page: Int = 0
    ) async throws -> ([Character], isNext: Bool) {
        let parameters: [String: String] = [
            "name": name ?? "",
            "status": status?.rawValue ?? "",
            "gender": gender?.rawValue ?? "",
            "page": "\(page)"
        ].filter { !$0.value.isEmpty }
        let response: RickAndMortyPageResponse<[Character]> = try await apiClient.request(
            baseURLString: baseURLString,
            path: Endpoints.character.rawValue,
            parameters: parameters
        )
        return (response.results, response.info.nextURL != nil)
    }
}
