//
//  CharacterDetailsViewModel.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 10/07/2023.
//

import UIKit
import Combine

class CharacterDetailsViewModel {

    private let imageService: ImageServiceProtocol
    private let character: Character
    @Published private(set) var image: UIImage?

    var name: String { character.name }
    var status: String { character.status.string }
    var species: String { character.species }
    var origin: String { character.origin.name }
    var currentLocation: String { character.location.name }

    init(
        imageService: ImageServiceProtocol,
        character: Character
    ) {
        self.imageService = imageService
        self.character = character
    }

    func viewDidLoad() {
        Task { [weak self] in
            guard let self = self else { return }

            let image = await imageService.loadImage(self.character.imageURL)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                self.image = image
            }
        }
    }
}
