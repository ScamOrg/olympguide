//
//  UIView+Constraints.swift
//  olympguide
//
//  Created by Tom Tim on 19.01.2025.
//

import UIKit

extension UIView {
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        
        var currentView = self.superview
        while let view = currentView {
            let constraintsToRemove = view.constraints.filter { constraint in
                return constraint.firstItem === self || constraint.secondItem === self
            }
            view.removeConstraints(constraintsToRemove)
            currentView = view.superview
        }
    }
}
