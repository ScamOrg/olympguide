//
//  UIClouserButton.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import UIKit

final class UIClosureButton : UIButton {
    var action : (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTap() {
        action?()
    }
}
