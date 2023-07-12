//
//  AppCoordinator.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 10/07/2023.
//

import UIKit

protocol AppCoordinatorDelegate: AnyObject {
    func showCharacterDetails(_ character: Character)
}

class AppCoordinator: NSObject, AppCoordinatorDelegate {

    private let imageRepository: any Repository<String, UIImage> = ImageRepository()
    private let apiClient: APIClient = APIClient()

    private let rootViewController: UINavigationController

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        let rickAndMortyService = RickAndMortyService(apiClient: apiClient)
        let imageService = ImageService(imageRepository: imageRepository)
        let viewModel = CharactersCollectionViewModel(
            rickAndMortyService: rickAndMortyService,
            imageService: imageService
        )
        viewModel.coordinator = self
        let viewController = CharactersCollectionViewController(viewModel: viewModel)
        rootViewController.viewControllers = [viewController]
    }

    func showCharacterDetails(_ character: Character) {
        let imageService = ImageService(imageRepository: imageRepository)
        let viewModel = CharacterDetailsViewModel(
            imageService: imageService,
            character: character
        )
        let viewController = CharacterDetailsViewController(viewModel: viewModel)
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .custom
        rootViewController.viewControllers.last?.present(viewController, animated: true)
    }
}

extension AppCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let transitionSource = source as? CustomTransitionSource,
              let transitionDestination = presented as? CustomTransitionDestination,
              let sourceData = transitionSource.customTransitionSourceData,
              let destinationData = transitionDestination.customTransitionDestinationData else {
            return nil
        }

        return CustomTransitionAnimator(
            sourceData: sourceData,
            destinationData: destinationData
        )
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
}
