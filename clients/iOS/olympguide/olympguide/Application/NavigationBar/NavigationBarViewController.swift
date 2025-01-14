//
//  NavigationBarViewController.swift
//  olympguide
//
//  Created by Tom Tim on 12.01.2025.
//

import UIKit

class NavigationBarViewController: UINavigationController {
    private var interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    fileprivate let miniLabel: UILabel = UILabel()
    private let miniSearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    init(_ text: String, rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        miniLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
//        configureMiniLabel()
//        configureMiniSearchButton()
//        navigationBar.isTranslucent = false
////        let appearance = UINavigationBarAppearance()
////        appearance.configureWithOpaqueBackground()
////        appearance.backgroundColor = .white
////
////        navigationBar.standardAppearance = appearance
////        navigationBar.scrollEdgeAppearance = appearance
////        // Если нужен compactAppearance для компактных состояний (например, при Landscape):
////        navigationBar.compactAppearance = appearance
//        
//        extendedLayoutIncludesOpaqueBars = false
//        delegate = self
//                
//        // Добавляем свой gesture (или используем UIScreenEdgePanGestureRecognizer).
//        // Важно, чтобы системный interactivePopGestureRecognizer не конфликтовал с нашим,
//        // поэтому иногда его отключают:
//        interactivePopGestureRecognizer?.isEnabled = false
//        
//        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
//        edgePan.edges = .left
//        view.addGestureRecognizer(edgePan)
    }
    
    // MARK: - Gesture
        
        @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
            let translation = gesture.translation(in: view)
            let progress = max(0, min(1, translation.x / view.bounds.width))
            
            switch gesture.state {
            case .began:
                // Создаём UIPercentDrivenInteractiveTransition и запускаем pop
                interactiveTransition = UIPercentDrivenInteractiveTransition()
                popViewController(animated: true)
                
            case .changed:
                interactiveTransition?.update(progress)
                
            case .ended, .cancelled:
                // Решаем, завершать переход или откатывать
                if progress > 0.3 {
                    interactiveTransition?.finish()
                } else {
                    interactiveTransition?.cancel()
                }
                interactiveTransition = nil
                
            default:
                break
            }
        }
    
    private func configureNavigationBar() {
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
    }
    
    func setLabelText(_ text: String) {
        miniLabel.text = text
    }
    
    func setMiniSearchButtonAction(target: AnyObject, action: Selector) {
        miniSearchButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func configureMiniLabel() {
        miniLabel.font = UIFont(name: "MontserratAlternates-Bold", size: 20)!
        
        navigationBar.addSubview(miniLabel)
        miniLabel.pinTop(to: navigationBar.topAnchor, 10)
        miniLabel.pinLeft(to: navigationBar.leadingAnchor, 20)
        
//        miniLabel.alpha = 0.0
    }
    
    
    
    private func configureMiniSearchButton() {
        navigationBar.addSubview(miniSearchButton)

        miniSearchButton.setHeight(27)
        miniSearchButton.setWidth(27)
        miniSearchButton.pinCenterY(to: miniLabel.centerYAnchor)
        miniSearchButton.pinRight(to: navigationBar.trailingAnchor, 20)
                
//        miniSearchButton.alpha = 0.0
    }
    
    func show() {
        miniLabel.alpha = 1.0
        miniSearchButton.alpha = 1.0
    }
    
    func hide() {
        miniLabel.alpha = 0.0
        miniSearchButton.alpha = 0.0
    }
    
    func isHide() -> Bool {
        return miniLabel.alpha == 0.0
    }
    
    
}


// MARK: - UINavigationControllerDelegate

extension NavigationBarViewController: UINavigationControllerDelegate {
    // Возвращаем аниматор для push или pop
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        // Создаём экземпляр аниматора и передаём ему операцию (push или pop).
        return CustomAnimator(operation: operation)
    }
    
    // Возвращаем интерактивный объект, если он у нас есть
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        
        // Если мы сейчас в процессе интерактивного pop, вернём наш UIPercentDrivenInteractiveTransition
        return interactiveTransition
    }
}

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // Храним тип операции (push или pop)
    private let operation: UINavigationController.Operation
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    // Длительность анимации
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
            animatePush(
                transitionContext: transitionContext,
                containerView: containerView,
                fromVC: fromVC,
                toVC: toVC,
                duration: duration
            )
        case .pop:
            animatePop(
                transitionContext: transitionContext,
                containerView: containerView,
                fromVC: fromVC,
                toVC: toVC,
                duration: duration
            )
        default:
            transitionContext.completeTransition(false)
        }
    }
    
    // MARK: - Push анимация
    
    private func animatePush(
        transitionContext: UIViewControllerContextTransitioning,
        containerView: UIView,
        fromVC: UIViewController,
        toVC: UIViewController,
        duration: TimeInterval
    ) {
        // Добавляем toView поверх
        containerView.addSubview(toVC.view)
        
        // Начальная позиция toView — сдвинута вправо за экран
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalFrame.offsetBy(dx: containerView.bounds.width, dy: 0)
        
        // --- Анимация miniLabel: исчезает при push ---
        // Предположим, что на экране сейчас fromVC, в нём (точнее, в его navigationController)
        // есть мини-лейбл, который мы хотим плавно убрать.
        if let navController = fromVC.navigationController as? NavigationBarViewController {
            let initialAlpha = navController.miniLabel.alpha  // запомним на всякий случай
            UIView.animate(withDuration: duration) {
                navController.miniLabel.alpha = 0
            } completion: { _ in
                // Если вдруг переход отменился (хотя интерактивный push — редкая история),
                // вернём всё обратно:
                if transitionContext.transitionWasCancelled {
                    navController.miniLabel.alpha = initialAlpha
                }
            }
        }
        
        // --- Анимация сдвига экрана ---
        UIView.animate(withDuration: duration, animations: {
            toVC.view.frame = finalFrame
        }, completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
    }
    
    // MARK: - Pop анимация
    
    private func animatePop(
        transitionContext: UIViewControllerContextTransitioning,
        containerView: UIView,
        fromVC: UIViewController,
        toVC: UIViewController,
        duration: TimeInterval
    ) {
        // toView вставляем под fromView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        let finalFrame = initialFrame.offsetBy(dx: containerView.bounds.width, dy: 0)
        
        // --- Анимация miniLabel: появляется при pop ---
        // Здесь логично брать toVC, потому что именно к нему мы «возвращаемся».
        // Если наш кастомный NavigationBarViewController живёт именно в toVC.navigationController:
        if let navController = toVC.navigationController as? NavigationBarViewController {
            // Ставим лейбл «в начало» (alpha=0), чтобы затем анимированно показать
            let initialAlpha = navController.miniLabel.alpha
            navController.miniLabel.alpha = 0
            
            UIView.animate(withDuration: duration) {
                navController.miniLabel.alpha = 1
            } completion: { _ in
                let wasCancelled = transitionContext.transitionWasCancelled
                // Если пользователь отменил pop свайпом, вернёмся к исходному alpha
                if wasCancelled {
                    navController.miniLabel.alpha = initialAlpha
                }
            }
        }
        
        // --- Анимация сдвига экрана ---
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.frame = finalFrame
        }, completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            
            // Если отменили pop, вернём всё обратно
            if wasCancelled {
                fromVC.view.frame = initialFrame
            }
            
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}
