//
//  ImageCollectionViewCell.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

// Define the image selected color
let selectedHighlightColor: UIColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)

class ImageCollectionViewCell: PhotoCell {
    
    override func didMoveToSuperview() {
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 4, height: 6)
        self.layer.shadowRadius = 5
    }

    //Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextView = context.nextFocusedView as? UICollectionViewCell {
            transitionToSelectedState(cell: nextView)
        }

        if let previousView = context.previouslyFocusedView as? UICollectionViewCell {
            transitionToUnselectedState(cell: previousView)
        }
    }
    
    override func transitionToSelectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.3,
                       options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.layer.shadowOpacity = 0.7
                        self.layer.shadowRadius = 20
                        self.layer.shadowColor = selectedHighlightColor.cgColor
        }, completion: nil)
    }
    
    override func transitionToUnselectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.layer.shadowOpacity = 0.3
                        self.layer.shadowRadius = 5
                        self.layer.shadowColor = UIColor.black.cgColor
        }, completion: nil)
    }
}
