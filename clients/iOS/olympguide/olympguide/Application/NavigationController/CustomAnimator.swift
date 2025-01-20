//
//  CustomAnimator.swift
//  olympguide
//
//  Created by Tom Tim on 20.01.2025.
//

import UIKit

final class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let operation: UINavigationController.Operation
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.35
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC   = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        
        switch operation {
        case .push:
            animatePush(transitionContext: transitionContext,
                        containerView: containerView,
                        fromVC: fromVC,
                        toVC: toVC,
                        duration: duration)
            
        case .pop:
            animatePop(transitionContext: transitionContext,
                       containerView: containerView,
                       fromVC: fromVC,
                       toVC: toVC,
                       duration: duration)
            
        default:
            // .none (или неизвестная операция)
            transitionContext.completeTransition(false)
        }
    }
    private func animatePush(transitionContext: UIViewControllerContextTransitioning,
                             containerView: UIView,
                             fromVC: UIViewController,
                             toVC: UIViewController,
                             duration: TimeInterval) {
        containerView.addSubview(toVC.view)
        
    }
    
    private func animatePop(transitionContext: UIViewControllerContextTransitioning,
                             containerView: UIView,
                             fromVC: UIViewController,
                             toVC: UIViewController,
                             duration: TimeInterval) {
    }
    
    
}
