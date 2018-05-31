//
//  PrivacyPolicyFocusableView.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 22/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class PrivacyPolicyFocusableView: FocusableView {
    // Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        // Focused
        if let nextView = context.nextFocusedView as? PrivacyPolicyFocusableView {
            UIView.animate(withDuration: 0.5, animations: {
                            nextView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion: nil)
        }
        
        // Unfocused
        if let previousView = context.previouslyFocusedView as? PrivacyPolicyFocusableView {
            UIView.animate(withDuration: 0.5, animations: {
                            previousView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
}
