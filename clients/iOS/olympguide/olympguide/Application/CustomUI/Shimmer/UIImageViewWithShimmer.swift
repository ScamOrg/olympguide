//
//  UIImageViewWithShimmer.swift
//  olympguide
//
//  Created by Tom Tim on 21.02.2025.
//

import UIKit

final class UIImageViewWithShimmer: UIImageView, Shimmerable {
    var shimmerView = UIShimmerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureShimmer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
