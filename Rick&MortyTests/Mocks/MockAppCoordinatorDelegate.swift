//
//  MockAppCoordinatorDelegate.swift
//  Rick&MortyTests
//
//  Created by Artur Peplinski on 11/07/2023.
//

import Foundation
@testable import Rick_Morty

final class MockAppCoordinatorDelegate: AppCoordinatorDelegate {

    private(set) var showCharacterDetailsCalled: Bool = false
    private(set) var dismissCharacterDetailsCalled: Bool = false

    func showCharacterDetails(_ character: Rick_Morty.Character) {
        showCharacterDetailsCalled = true
    }

    func dismissCharacterDetails() {
        dismissCharacterDetailsCalled = true
    }
}
