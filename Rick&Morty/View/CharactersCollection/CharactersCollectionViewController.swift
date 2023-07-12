//
//  CharactersCollectionViewController.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 06/07/2023.
//

import UIKit
import Combine

class CharactersCollectionViewController: UIViewController {

    private var transitionData: CustomTransitionAnimator.SourceData?

    enum Section: Int, CaseIterable {
        case characters
    }

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                switch Section(rawValue: sectionIndex) {
                case .characters:
                    return self?.createCustomLayout()

                case nil:
                    return nil
                }
            }
        )
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.regiser(CharacterImageCell.self)
        return view
    }()

    private let noResultsLabel: UILabel = {
        let view = UILabel.withoutAutoLayout()
        view.font = .italicSystemFont(ofSize: 15.0)
        view.text = "No results found"
        view.isHidden = true
        return view
    }()

    private let preventLargeTitleCollapseView: UIView = .withoutAutoLayout()

    private let filtersViewContainer: UIStackView = {
        let view = UIStackView.withoutAutoLayout()
        view.axis = .vertical
        view.isHidden = true
        return view
    }()

    private let viewModel: CharactersCollectionViewModel

    private lazy var dataSource = makeDataSource()

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: CharactersCollectionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Rick&Morty characters"
        setUpUI()
        setUpBindings()

        collectionView.dataSource = dataSource

        viewModel.viewDidLoad()
    }

    // MARK: - Private

    private func setUpUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(didPressFiltersButton(_:))
        )

        view.addSubview(preventLargeTitleCollapseView)
        NSLayoutConstraint.activate([
            preventLargeTitleCollapseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preventLargeTitleCollapseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            preventLargeTitleCollapseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            preventLargeTitleCollapseView.heightAnchor.constraint(equalToConstant: 0.0)
        ])

        view.addSubview(filtersViewContainer)
        NSLayoutConstraint.activate([
            filtersViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filtersViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filtersViewContainer.topAnchor.constraint(equalTo: preventLargeTitleCollapseView.bottomAnchor)
        ])

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: filtersViewContainer.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.addSubview(noResultsLabel)
        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setUpBindings() {
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.updateCollectionViewSnapshot(with: $0)
            }
            .store(in: &cancellables)

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle,
                        .endOfData,
                        .loading:
                    self?.noResultsLabel.isHidden = true

                case .failure:
                    break // TODO: handle error

                case .noResults:
                    self?.noResultsLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    private func updateCollectionViewSnapshot(with characters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(characters, toSection: .characters)
        dataSource.apply(snapshot)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Character> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, character in
            let cell = collectionView.dequeue(CharacterImageCell.self, for: indexPath) as! CharacterImageCell
            let cellViewModel = CharacterImageViewModel(
                imageService: self.viewModel.imageService,
                character: character
            )
            cell.update(with: cellViewModel)
            return cell
        }
    }

    @objc private func didPressFiltersButton(_ button: UIBarButtonItem) {
        guard filtersViewContainer.isHidden else { return }

        filtersViewContainer.isHidden = false

        let filtersViewModel = FilterViewModel(searchText: viewModel.name)
        let view = FiltersView(viewModel: filtersViewModel)
        self.filtersViewContainer.addArrangedSubview(view)

        filtersViewModel.didClearPublisher
            .sink { [weak self, weak view, weak button] _ in
                view?.removeFromSuperview()
                self?.filtersViewContainer.isHidden = true
                button?.isSelected = false
                self?.viewModel.updateFilters(nil)
            }
            .store(in: &cancellables)

        filtersViewModel.didFilterPublisher
            .sink { [weak self, weak view, weak button] text in
                view?.removeFromSuperview()
                self?.filtersViewContainer.isHidden = true
                button?.isSelected = text != nil && text?.isEmpty == false
                self?.viewModel.updateFilters(text)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate

extension CharactersCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let characterImageCell = cell as? CharacterImageCell {
            characterImageCell.willDisplayCell()
        }

        guard viewModel.state == .idle, indexPath.item == viewModel.characters.count - 1 else {
            return
        }

        viewModel.didScrollToTheEndOfData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        transitionData = CustomTransitionAnimator.SourceData(
            triggerView: cell,
            snapshotOrigin: cell.contentView.convert(cell.contentView.frame, to: view)
        )
        viewModel.didSelectCharacter(at: indexPath.item)
    }
}

// MARK: - Layout related functions

extension CharactersCollectionViewController {
    private func createCustomLayout() -> NSCollectionLayoutSection {
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(1.0) // will automatically take available height
            ),
            subitems: [
                createFirstSubsection(),
                createSecondSubsection(),
                createThirdSubsectionGroup(),
                createFourthSubsectionGroup()
            ]
        )

        return NSCollectionLayoutSection(group: group)
    }

    private func createFirstSubsection() -> NSCollectionLayoutGroup {
        let bigLeft = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.5)
            )
        )
        bigLeft.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        let smallRight = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        smallRight.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        let row = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.5)
            ),
            repeatingSubitem: smallRight,
            count: 2
        )

        let gridRight = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.5)
            ),
            repeatingSubitem: row,
            count: 2
        )

        return .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitems: [bigLeft, gridRight]
        )
    }

    private func createSecondSubsection() -> NSCollectionLayoutGroup {
        let smallLeft = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0 / 3.0)
            )
        )
        smallLeft.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        let groupLeft = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .fractionalWidth(0.75)
            ),
            repeatingSubitem: smallLeft,
            count: 3
        )
        groupLeft.interItemSpacing = .fixed(1.0)

        let bigRight = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.75),
                heightDimension: .fractionalWidth(0.75)
            )
        )
        bigRight.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        return .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.75)
            ),
            subitems: [groupLeft, bigRight]
        )
    }

    private func createThirdSubsectionGroup() -> NSCollectionLayoutGroup {
        let bigMiddle = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        bigMiddle.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        let small = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            )
        )
        small.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        let column = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .fractionalWidth(0.5)
            ),
            repeatingSubitem: small,
            count: 2
        )

        return .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitems: [column, bigMiddle, column]
        )
    }

    private func createFourthSubsectionGroup() -> NSCollectionLayoutGroup {
        let small = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        small.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        let row = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            ),
            repeatingSubitem: small,
            count: 2
        )

        let big = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)
            )
        )
        big.contentInsets = .init(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)

        let leftGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitems: [row, big]
        )

        let rightGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitems: [big, row]
        )

        return .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.75)
            ),
            subitems: [leftGroup, rightGroup]
        )
    }
}

extension CharactersCollectionViewController: CustomTransitionSource {
    var customTransitionSourceData: CustomTransitionAnimator.SourceData? {
        transitionData
    }
}
