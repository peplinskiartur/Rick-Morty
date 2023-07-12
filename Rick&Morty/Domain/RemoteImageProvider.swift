//
//  RemoteImageProvider.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 11/07/2023.
//

import Foundation

protocol RemoteImageProvider {
    func imageData(from: URL) async throws -> Data
}

extension URLSession: RemoteImageProvider {
    func imageData(from url: URL) async throws -> Data {
        try await data(from: url).0
    }
}
