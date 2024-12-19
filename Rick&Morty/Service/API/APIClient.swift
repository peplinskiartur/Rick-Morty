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
        path: String,
        parameters: [String: String]?
    ) async throws -> Response

    func request<Response: Decodable>(
        baseURLString: String,
        path: String
    ) async throws -> Response
}

class APIClient: APIClientProtocol {
    private let urlSession: URLSession = .shared

    func request<Response: Decodable>(
        baseURLString: String,
        path: String,
        parameters: [String: String]? = nil
    ) async throws -> Response {

        let urlRequest = try urlRequest(
            baseURLString: baseURLString,
            path: path,
            parameters: parameters
        )

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw "No status code" // TODO: add support in case of missing status code
        }

        switch statusCode {
        case 200..<300:
            break
        default:
            throw "Wrong status code" // TODO: add support of different API error codes and other side cases if needed
        }

        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormmatter)
        return try jsonDecoder.decode(Response.self, from: data)
    }

    func request<Response: Decodable>(baseURLString: String, path: String) async throws -> Response {
        try await request(
            baseURLString: baseURLString,
            path: path,
            parameters: nil
        )
    }

    // MARK: - Private

    private func urlRequest(
        baseURLString: String,
        path: String,
        parameters: [String: String]? = nil
    ) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURLString
        urlComponents.path = path
        urlComponents.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            throw "Couldn't produce a valid URL"
        }

        return URLRequest(url: url)
    }
}
