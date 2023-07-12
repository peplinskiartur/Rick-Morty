//
//  FiltersView.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 12/07/2023.
//

import UIKit

class FiltersView: UIView {

    enum Constants {
        static var margin: CGFloat = 16.0
        static var spacing: CGFloat = 8.0
    }

    private lazy var searchView: UISearchBar = {
        let view = UISearchBar.withoutAutoLayout()
        view.delegate = self
        view.searchBarStyle = .minimal
        view.searchTextField.enablesReturnKeyAutomatically = false
        view.searchTextField.returnKeyType = .done
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView.withoutAutoLayout()
        view.axis = .vertical
        view.spacing = Constants.spacing
        view.distribution = .equalSpacing
        return view
    }()

    private let actionsStackView: UIStackView = {
        let view = UIStackView.withoutAutoLayout()
        view.axis = .horizontal
        view.spacing = Constants.spacing
        view.distribution = .fillEqually
        return view
    }()

    private let clearButton: UIButton = {
        let view = UIButton(type: .system).withoutAutoLayout()
        view.tintColor = .black
        view.setTitle("Clear", for: .normal)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()

    private let proceedButton: UIButton = {
        let view = UIButton(type: .system).withoutAutoLayout()
        view.tintColor = .white
        view.setTitle("Filter", for: .normal)
        view.backgroundColor = .black
        return view
    }()

    private let viewModel: FilterViewModel

    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setUpUI()
        setUpBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.margin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.margin),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.margin)
        ])

        [
            searchView,
            actionsStackView
        ].forEach(stackView.addArrangedSubview)

        [
            clearButton,
            proceedButton
        ].forEach(actionsStackView.addArrangedSubview)
    }

    private func setUpBindings() {
        searchView.text = viewModel.searchText

        clearButton.addTarget(self, action: #selector(didPressClearButton), for: .touchUpInside)
        proceedButton.addTarget(self, action: #selector(didPressProceedButton), for: .touchUpInside)
    }

    @objc private func didPressClearButton() {
        viewModel.didPressClearButton()
    }

    @objc private func didPressProceedButton() {
        viewModel.didPressProceedButton()
    }
}

extension FiltersView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didEnterSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
