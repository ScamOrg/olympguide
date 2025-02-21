//
//  UIButtonWithShimmer.swift
//  olympguide
//
//  Created by Tom Tim on 21.02.2025.
//

import UIKit

final class UIButtonWithShimmer: UIButton, Shimmerable {
    var shimmerView = UIShimmerView()
    
    init() {
        super.init(frame: .zero)
        configureShimmer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
