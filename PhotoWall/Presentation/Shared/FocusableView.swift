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
}

extension FocusableView {
    
    //Define whether a view can become focused or not
    override var canBecomeFocused: Bool {
        return true
    }
    
    //Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        // Focused
        if let nextView = context.nextFocusedView as? FocusableView {
            UIView.animate(withDuration: 0.5, delay: 0,
                           usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1,
                           options: UIViewAnimationOptions.beginFromCurrentState,
                           animations: {
                nextView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        }
        
        // Unfocused
        if let previousView = context.previouslyFocusedView as? FocusableView {
            UIView.animate(withDuration: 0.5, delay: 0,
                           usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1,
                           options: UIViewAnimationOptions.beginFromCurrentState,
                           animations: {
                previousView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
}
