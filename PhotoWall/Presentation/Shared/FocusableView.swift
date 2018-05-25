//
//  FocusableView.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class FocusableView: UIView {
    func bounce() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
        })
    }
    
    // Define whether a view can become focused or not
    override var canBecomeFocused: Bool {
        return true
    }
    
    // Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        // Focused
        if let nextView = context.nextFocusedView as? FocusableView {
            self.scale(view: nextView, to: 1.1)
        }
        
        // Unfocused
        if let previousView = context.previouslyFocusedView as? FocusableView {
            self.scale(view: previousView, to: 1.0)
        }
    }
    
    // Scales a view by the same factor in X and Y
    private func scale(view: FocusableView, to scaleFactor: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        view.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }, completion: nil)
    }
}
