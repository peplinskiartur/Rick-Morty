//
//  Character.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import Foundation

struct Character: Hashable, Decodable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    enum Status: String, Decodable {
        case alive
        case dead
        case unknown

        var string: String { rawValue.capitalized }
    }

    enum Gender: String, Decodable {
        case male
        case female
        case genderless
        case unknown

        var string: String { rawValue.capitalized }
    }

    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let imageURL: String
    let episodes: [Episode]
    let url: String
    let created: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case imageURL = "image"
        case episodes = "episode"
        case url
        case created
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        let status = try container.decode(String.self, forKey: .status)
        self.status = Status(rawValue: status.capitalized) ?? .unknown
        self.species = try container.decode(String.self, forKey: .species)
        self.type = try container.decode(String.self, forKey: .type)
        let gender = try container.decode(String.self, forKey: .gender)
        self.gender = Gender(rawValue: gender.capitalized) ?? .unknown
        self.origin = try container.decode(Location.self, forKey: .origin)
        self.location = try container.decode(Location.self, forKey: .location)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        let episodes = try container.decode([String].self, forKey: .episodes)
        self.episodes = episodes.map(Episode.init(url:))
        self.url = try container.decode(String.self, forKey: .url)
        self.created = try container.decode(Date.self, forKey: .created)
    }

    init(
        id: Int,
        name: String,
        status: Status,
        species: String,
        type: String,
        gender: Gender,
        origin: Location,
        location: Location,
        imageURL: String,
        episodes: [Episode],
        url: String,
        created: Date
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.imageURL = imageURL
        self.episodes = episodes
        self.url = url
        self.created = created
    }
}
