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

    private let imageView: UIImageView = .withoutAutoLayout()
    private let nameLabel: UILabel = {
        let view = UILabel.withoutAutoLayout()
        view.font = .boldSystemFont(ofSize: 40.0)
        view.numberOfLines = 0
        return view
    }()
    private let statusLabel: UILabel = .withoutAutoLayout()
    private let speciesLabel: UILabel = .withoutAutoLayout()
    private let originLabel: UILabel = {
        let view = UILabel.withoutAutoLayout()
        view.numberOfLines = 0
        return view
    }()
    private let currentLocationLabel: UILabel = {
        let view = UILabel.withoutAutoLayout()
        view.numberOfLines = 0
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView.withoutAutoLayout()
        view.axis = .vertical
        view.spacing = Constants.spacing
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.backgroundColor = .black
        view.layoutMargins = .init(
            top: Constants.margin,
            left: Constants.margin,
            bottom: Constants.margin,
            right: Constants.margin
        )
        view.isLayoutMarginsRelativeArrangement = true
        view.layer.cornerRadius = 10.0
        return view
    }()

    private let viewModel: CharacterDetailsViewModel

    private var viewTranslation = CGPoint(x: 0, y: 0)
    private var dismissTreshold: CGFloat = 200.0

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
        ].forEach {
            self.stackView.addArrangedSubview($0)
            $0.textColor = .white
        }
    }

    private func setUpBindings() {
        viewModel.$image
            .sink { [weak self] in self?.imageView.image = $0 }
            .store(in: &cancellables)

        nameLabel.text = viewModel.name
        statusLabel.text = "Status: " + viewModel.status
        speciesLabel.text = "Species: " + viewModel.species
        originLabel.text = "Origin: " + viewModel.origin
        currentLocationLabel.text = "Current location: " + viewModel.currentLocation

        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }

    @objc private func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: max(0, self.viewTranslation.y))
                }
            )

        case .ended:
            if viewTranslation.y < dismissTreshold {
                UIView.animate(
                    withDuration: 0.35,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 1,
                    options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                    animations: {
                        self.view.transform = .identity
                    }
                )
            } else {
                viewModel.didScrollToDismiss()
            }

        default:
            break
        }
    }
}

extension CharacterDetailsViewController: CustomTransitionDestination {
    var customTransitionDestinationData: CustomTransitionAnimator.DesitionationData? {
        .init(
            destinationImageView: imageView
        )
    }
}
