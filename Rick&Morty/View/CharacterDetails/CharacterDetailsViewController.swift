//
//  CharacterDetailsViewController.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import UIKit
import Combine

class CharacterDetailsViewController: UIViewController {

    enum Constants {
        static var margin: CGFloat = 16.0
        static var spacing: CGFloat = 8.0
    }

    private let closeButton: UIButton = {
        let view = UIButton(type: .system).withoutAutoLayout()
        view.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        view.tintColor = .white
        return view
    }()

    private let imageView: UIImageView = .withoutAutoLayout()
    private let nameLabel: UILabel = {
        let view = UILabel.withoutAutoLayout()
        view.font = .boldSystemFont(ofSize: 40.0)
        view.numberOfLines = 0
        return view
    }()
    private let statusLabel: UILabel = .withoutAutoLayout()
    private let speciesLabel: UILabel = .withoutAutoLayout()
    private let originLabel: UILabel = .withoutAutoLayout()
    private let currentLocationLabel: UILabel = .withoutAutoLayout()

    private let stackView: UIStackView = {
        let view = UIStackView.withoutAutoLayout()
        view.axis = .vertical
        view.spacing = Constants.spacing
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()

    private let gradientView: GradientView = .withoutAutoLayout()

    private let viewModel: CharacterDetailsViewModel

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpBindings()
        viewModel.viewDidLoad()
    }

    private func setUpUI() {
        view.backgroundColor = .white

        view.addSubview(imageView)
        imageView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0)
        ])

        view.addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.5)
        ])

        gradientView.startLocation = 0.1
        gradientView.endLocation = 0.95
        gradientView.startColor = .clear
        gradientView.endColor = .white

        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.margin),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor, multiplier: 1.0)
        ])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.margin),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.margin),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.margin)
        ])

        [
            nameLabel,
            statusLabel,
            speciesLabel,
            originLabel,
            currentLocationLabel
        ].forEach(stackView.addArrangedSubview)
    }

    private func setUpBindings() {
        closeButton.addTarget(self, action: #selector(didPressCloseButton), for: .touchUpInside)

        viewModel.$image
            .sink { [weak self] in self?.imageView.image = $0 }
            .store(in: &cancellables)

        nameLabel.text = viewModel.name
        statusLabel.text = "Status: " + viewModel.status
        speciesLabel.text = "Species: " + viewModel.species
        originLabel.text = "Origin: " + viewModel.origin
        currentLocationLabel.text = "Current location: " + viewModel.currentLocation
    }

    @objc private func didPressCloseButton() {
        dismiss(animated: true)
    }
}

extension CharacterDetailsViewController: CustomTransitionDestination {
    var customTransitionDestinationData: CustomTransitionAnimator.DesitionationData? {
        .init(
            destinationImageView: imageView
        )
    }
}
