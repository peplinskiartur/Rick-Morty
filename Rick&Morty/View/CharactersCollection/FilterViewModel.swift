//
//  FilterViewModel.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 12/07/2023.
//

import Foundation
import Combine

class FilterViewModel {

    private let _didClearSubject: PassthroughSubject<Bool, Never> = .init()
    var didClearPublisher: any Publisher<Bool, Never> {
        _didClearSubject.eraseToAnyPublisher()
    }

    private let _didFilterSubject: PassthroughSubject<String?, Never> = .init()
    var didFilterPublisher: any Publisher<String?, Never> {
        _didFilterSubject.eraseToAnyPublisher()
    }

    private(set) var searchText: String?

    init(searchText: String?) {
        self.searchText = searchText
    }

    func didEnterSearchText(_ text: String?) {
        searchText = text
    }

    func didPressClearButton() {
        searchText = nil
        _didClearSubject.send(true)
    }

    func didPressProceedButton() {
        _didFilterSubject.send(searchText)
    }
}
