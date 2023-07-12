//
//  MockCharacter.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import Foundation
@testable import Rick_Morty

extension Character {
    static var mock: Character = Character(
        id: 0,
        name: "",
        status: .unknown,
        species: "",
        type: "",
        gender: .unknown,
        origin: .init(name: ""),
        location: .init(name: ""),
        imageURL: "test_image_url",
        episodes: [],
        url: "",
        created: .now
    )
}
