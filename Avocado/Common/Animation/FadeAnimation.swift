//
//  FadeAnimation.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/24.
//

import Foundation
import UIKit

class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0.0

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

class FadeOutTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
