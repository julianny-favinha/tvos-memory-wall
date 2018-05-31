//
//  CustomizationCollectionViewCell.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class CustomizationCollectionViewCell: ImageCollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    override func didMoveToSuperview() {
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 3, height: 2)
    }
    
    // Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let cell = context.nextFocusedView as? CustomizationCollectionViewCell {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                cell.transitionToSelectedState()
            }, completion: nil)
        }
        
        if let cell = context.previouslyFocusedView as? CustomizationCollectionViewCell {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transitionToUnselectedState()
            }, completion: nil)
        }
    }
    
    func transitionToSelectedState() {
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    func transitionToUnselectedState() {
        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
}
