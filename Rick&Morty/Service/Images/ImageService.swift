//
//  ImageService.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 07/07/2023.
//

import UIKit

protocol ImageServiceProtocol {
    func loadImage(_ urlString: String) async -> UIImage
}

class ImageService: ImageServiceProtocol {

    private let remoteImageProvider: RemoteImageProvider
    private let imageRepository: any Repository<String, UIImage>

    init(
        remoteImageProvider: RemoteImageProvider = URLSession.shared,
        imageRepository: any Repository<String, UIImage>
    ) {
        self.remoteImageProvider = remoteImageProvider
        self.imageRepository = imageRepository
    }

    func loadImage(_ urlString: String) async -> UIImage {
        if let image = imageRepository.get(urlString) {
            return image
        }

        guard let url = URL(string: urlString),
              let data = try? await remoteImageProvider.imageData(from: url),
              let image = UIImage(data: data) else {
            return #imageLiteral(resourceName: "No_image_found")
        }

        imageRepository.set(image, for: urlString)
        return image
    }
}
