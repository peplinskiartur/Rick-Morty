//
//  CharactersCollectionViewModel.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import UIKit
import Combine

class CharactersCollectionViewModel {
    enum LoadingState {
        case idle 
        case loading
        case endOfData
        case failure
        case noResults
    }

    private var page: Int = 1

    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var characters: [Character] = []
    private(set) var name: String? = nil

    private let rickAndMortyService: RickAndMortyServiceProtocol
    private(set) var imageService: ImageServiceProtocol

    weak var coordinator: AppCoordinatorDelegate?

    private var task: Task<(), Error>?

    private var status: Character.Status?


    init(
        rickAndMortyService: RickAndMortyServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.rickAndMortyService = rickAndMortyService
        self.imageService = imageService
    }

    func viewDidLoad() {
        task = Task { [weak self] in
            do {
                try await self?.getCharacters()
            } catch {
                print(error)
            }
        }
    }

    func didScrollToTheEndOfData() {
        guard state == .idle else { return }

        page += 1
        task = Task { [weak self] in
            try await self?.getCharacters()
        }
    }

    func didSelectCharacter(at index: Int) {
        let character = characters[index]
        coordinator?.showCharacterDetails(character)
    }

    func updateFilters(_ searchText: String?) {
        cancelOngoingTask()
        resetState()

        name = searchText

        task = Task { [weak self] in
            try await self?.getCharacters()
        }
    }

    // MARK: - Private

    private func getCharacters(
        name: String? = nil,
        status: Character.Status? = nil,
        gender: Character.Gender? = nil
    ) async throws {
        state = .loading

        do {
            let (characters, isNext) = try await rickAndMortyService.getCharacters(
                name: self.name,
                status: nil,
                gender: nil,
                page: page
            )

            guard !Task.isCancelled else { return }
            await MainActor.run { [weak self] in
                self?.state = isNext ? .idle : .endOfData
                self?.characters += characters
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.state = .noResults
                self?.characters = []
            }
        }
    }

    private func resetState() {
        page = 1
        state = .idle
        characters = []
    }

    private func cancelOngoingTask() {
        task?.cancel()
        task = nil
    }
}
