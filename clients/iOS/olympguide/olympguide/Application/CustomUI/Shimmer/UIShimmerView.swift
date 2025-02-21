//
//  ShimmerView.swift
//  vmpankratovPW5
//
//  Created by Tom Tim on 17.12.2024.
//

import UIKit

final class UIShimmerView: UIView {
    // MARK: - Constants
    enum Constants {
        static let firstGradientColor: CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        static let secondGradientColor: CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        
        static let startPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)
        static let endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)
        
        static let gradientLayerLocations: [NSNumber] = [0.0, 0.5, 1.0]
        
        static let keyPath: String = "locations"
        
        static let fromValue: [NSNumber] = [-1.0, -0.5, 0.0]
        static let toValue: [NSNumber] = [1.0, 1.5, 2.0]
        
        static let animationDuration = 0.9
    }
    
    // MARK: - Private Properties
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Public Methods
    func startAnimating() {
        // Если уже есть слой, не добавляем повторно
        guard gradientLayer == nil else { return }
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = Constants.startPoint
        gradient.endPoint = Constants.endPoint
        gradient.colors = [Constants.firstGradientColor, Constants.secondGradientColor, Constants.firstGradientColor]
        gradient.locations = Constants.gradientLayerLocations
        gradient.cornerRadius = layer.cornerRadius
        layer.addSublayer(gradient)
        gradientLayer = gradient
        
        let animation = CABasicAnimation(keyPath: Constants.keyPath)
        animation.fromValue = Constants.fromValue
        animation.toValue = Constants.toValue
        animation.duration = Constants.animationDuration
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopAnimating() {
        gradientLayer?.removeAllAnimations()
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}
