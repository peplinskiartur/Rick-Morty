//
//  CharacterImageCell.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 07/07/2023.
//

import UIKit
import Combine

class CharacterImageCell: UICollectionViewCell {

    private(set) var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var viewModel: CharacterImageViewModel?

    private var cancellables: Set<AnyCancellable> = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setUpBindings() {
        viewModel?.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.imageView.image = $0
            }
            .store(in: &cancellables)
    }

    func update(with viewModel: CharacterImageViewModel) {
        self.viewModel = viewModel

        setUpBindings()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel?.prepareForReuse()
    }

    func willDisplayCell() {
        viewModel?.willDisplayCell()
    }
}


