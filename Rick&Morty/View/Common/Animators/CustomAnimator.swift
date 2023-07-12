//
//  CustomAnimator.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 10/07/2023.
//

import UIKit

protocol CustomTransitionSource {
    var customTransitionSourceData: CustomTransitionAnimator.SourceData? { get }
}

protocol CustomTransitionDestination {
    var customTransitionDestinationData: CustomTransitionAnimator.DesitionationData? { get }
}

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    struct SourceData {
        let triggerView: UIView?
        let snapshotOrigin: CGRect?

        init(triggerView: UIView?, snapshotOrigin: CGRect?) {
            self.triggerView = triggerView
            self.snapshotOrigin = snapshotOrigin
        }
    }

    struct DesitionationData {
        let destinationImageView: UIView?
    }

    private let animationDuration: CGFloat = 0.35

    private let sourceData: SourceData
    private let destinationData: DesitionationData

    init(
        sourceData: SourceData,
        destinationData: DesitionationData
    ) {
        self.sourceData = sourceData
        self.destinationData = destinationData
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        guard let triggerView = sourceData.triggerView,
              let triggerViewSnapshot = triggerView.snapshotView(afterScreenUpdates: true),
              let snapshotOrigin = sourceData.snapshotOrigin else {
            return
        }

        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView

        triggerView.alpha = 0.0

        let toViewControllerBackgroundColor = toViewController.view.backgroundColor
        let backgroundView = UIView(frame: finalFrame)
        backgroundView.alpha = 0.0
        backgroundView.backgroundColor = toViewControllerBackgroundColor

        containerView.addSubview(backgroundView)
        containerView.addSubview(triggerViewSnapshot)
        triggerViewSnapshot.frame = snapshotOrigin
        containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0.0

        UIView.animateKeyframes(
            withDuration: animationDuration,
            delay: 0.0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.3
                ) {
                    triggerViewSnapshot.frame = .init(
                        origin: .zero,
                        size: CGSize(width: finalFrame.width, height: finalFrame.width)
                    )
                    backgroundView.alpha = 1.0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                    toViewController.view.alpha = 1.0
                }

            },
            completion: { finished in
                triggerView.alpha = 1.0
                triggerViewSnapshot.alpha = 0.0
                backgroundView.removeFromSuperview()

                toViewController.view.alpha = 1.0
                transitionContext.completeTransition(finished)
            }
        )
    }
}
