//
//  UITextFieldWithShimmer.swift
//  olympguide
//
//  Created by Tom Tim on 21.02.2025.
//

import UIKit

public class UILabelWithShimmer: UILabel, Shimmerable {
    var shimmerView: UIShimmerView = UIShimmerView()
    
    init() {
        super.init(frame: .zero)
        configureShimmer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
