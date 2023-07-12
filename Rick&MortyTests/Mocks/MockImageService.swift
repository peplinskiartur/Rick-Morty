//
//  MockImageService.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import UIKit
@testable import Rick_Morty

final class MockImageService: ImageServiceProtocol {
    private let fallbackImage: UIImage = UIImage(named: "No_image_found")!
    var result: Result<UIImage, Error> = .failure("no image found")

    func loadImage(_ urlString: String) async -> UIImage {
        (try? result.get()) ?? fallbackImage
    }
}
