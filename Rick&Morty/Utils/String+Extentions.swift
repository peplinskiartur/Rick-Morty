//
//  String+Extentions.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
