//
//  RegionTextField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

final class RegionTextField: CustomTextField {
    init(with title: String, regions: [String]) {
        super.init(with: title)
        isUserInteractionEnabled(false)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
