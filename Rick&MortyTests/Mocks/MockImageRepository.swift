//
//  MockImageRepository.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import UIKit
@testable import Rick_Morty

class MockImageRepository: Repository {

    private var cache: [String: UIImage] = [:]

    func get(_ key: String) -> UIImage? {
        cache[key]
    }

    func set(_ object: UIImage, for key: String) {
        cache[key] = object
    }
}
