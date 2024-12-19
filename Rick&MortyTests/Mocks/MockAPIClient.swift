//
//  MockAPIClient.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import Foundation
@testable import Rick_Morty

final class MockAPIClient: APIClientProtocol {
    var result: Result<Decodable, Error> = .failure("no results")

    func request<Response>(baseURLString: String, path: String, parameters: [String : String]?) async throws -> Response where Response : Decodable {
        try result.get() as! Response
    }

    func request<Response>(baseURLString: String, path: String) async throws -> Response where Response : Decodable {
        try await request(baseURLString: baseURLString, path: path, parameters: nil)
    }
}
