//
//  ImageRepository.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 07/07/2023.
//

import UIKit

class ImageRepository: Repository {

    private let cache = NSCache<NSString, UIImage>()

    func get(_ key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }

    func set(_ object: UIImage, for key: String) {
        cache.setObject(object, forKey: NSString(string: key))
    }
}
