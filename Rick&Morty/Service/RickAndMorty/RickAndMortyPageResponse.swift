//
//  RickAndMortyPageResponse.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 10/07/2023.
//

import Foundation

struct RickAndMortyPageResponse<T: Decodable>: Decodable {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let nextURL: String?
        let prevURL: String?

        enum CodingKeys: String, CodingKey {
            case count
            case pages
            case nextURL = "next"
            case prevURL = "prev"
        }
    }

    let info: Info
    let results: T
}
