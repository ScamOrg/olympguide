//
//  Shimmerable.swift
//  olympguide
//
//  Created by Tom Tim on 21.02.2025.
//

import UIKit

protocol Shimmerable : UIView {
    var shimmerView: UIShimmerView { get set}
    func startShimmer()
    func stopShimmer()
    func configureShimmer()
}

extension Shimmerable {
    func configureShimmer() {
        addSubview(shimmerView)
        bringSubviewToFront(shimmerView)

        shimmerView.pinTop(to: topAnchor)
        shimmerView.pinLeft(to: leadingAnchor)
        shimmerView.pinRight(to: trailingAnchor)
        shimmerView.pinBottom(to: bottomAnchor)

        shimmerView.layer.cornerRadius = 5
        shimmerView.isHidden = true
    }
    
    func startShimmer() {
        shimmerView.isHidden = false
        shimmerView.startAnimating()
    }
    
    func stopShimmer() {
        shimmerView.stopAnimating()
        shimmerView.isHidden = true
    }
}
