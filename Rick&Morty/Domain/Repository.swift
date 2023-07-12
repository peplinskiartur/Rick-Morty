//
//  Repository.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 07/07/2023.
//

import Foundation

protocol Repository<Key, Object> {

    associatedtype Key: Equatable
    associatedtype Object

    func get(_ key: Key) -> Object?
    func set(_ object: Object, for key: Key)
}
