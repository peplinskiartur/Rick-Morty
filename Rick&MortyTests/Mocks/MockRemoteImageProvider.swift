//
//  MockRemoteImageProvider.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import Foundation
@testable import Rick_Morty

final class MockRemoteImageProvider: RemoteImageProvider {

    var result: Result<Data, Error> = .failure("no image data")

    func imageData(from: URL) async throws -> Data {
        try result.get()
    }
}
