//
//  MovementButton.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class MovementButton: UIButton {
    
    var delegate: MovementButtonDelegate?

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedView == self {
            delegate?.stopMoving()
        } else if context.nextFocusedView == self {
            delegate?.startMoving()
        }
    }
    
    // Fade out Button
    func fadeOut() {
        UIView.animate(withDuration: 3) {
            self.alpha = 0
        }
    }
    
    // Show button
    func showIn(){
        self.layer.removeAllAnimations()
        self.alpha = 1
    }

}

protocol MovementButtonDelegate {
    func startMoving()
    func stopMoving()
}
