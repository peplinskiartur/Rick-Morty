//
//  CharacterImageViewModel.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 07/07/2023.
//

import UIKit

class CharacterImageViewModel {

    private let service: ImageServiceProtocol
    private let character: Character
    private var task: Task<(), Error>?

    @Published private(set) var image: UIImage?

    init(
        imageService: ImageServiceProtocol,
        character: Character
    ) {
        self.service = imageService
        self.character = character
    }

    func willDisplayCell() {
        task = Task { [weak self] in
            guard let self = self else { return }
            let image = await service.loadImage(self.character.imageURL)

            guard !Task.isCancelled else { return }
            await MainActor.run {
                self.image = image
            }
        }
    }

    func prepareForReuse() {
        image = nil
        task?.cancel()
        task = nil
    }
}

