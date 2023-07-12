//
//  APIClient.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import Foundation

protocol APIClientProtocol {
    func request<Response: Decodable>(
        baseURLString: String,
        parameters: [String: String]?
    ) async throws -> Response

    func request<Response: Decodable>(
        baseURLString: String
    ) async throws -> Response
}

class APIClient: APIClientProtocol {
    private let urlSession: URLSession = .shared

    func request<Response: Decodable>(
        baseURLString: String,
        parameters: [String: String]? = nil
    ) async throws -> Response {

        let urlRequest = try urlRequest(baseURLString: baseURLString, parameters: parameters)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw "No status code" // TODO: error
        }

        switch statusCode {
        case 200..<300:
            break
        default:
            throw "Wrong status code"
        }

        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormmatter)
        return try jsonDecoder.decode(Response.self, from: data)
    }

    func request<Response: Decodable>(baseURLString: String) async throws -> Response {
        try await request(baseURLString: baseURLString, parameters: nil)
    }

    // MARK: - Private

    private func urlRequest(
        baseURLString: String,
        parameters: [String: String]? = nil
    ) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURLString
        urlComponents.path = "/api/character"
        urlComponents.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            throw "Couldn't produce a valid URL"
        }

        return URLRequest(url: url)
    }
}
