//
//  ImageCollectionViewCell.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func didMoveToSuperview() {
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 4, height: 6)
        self.layer.shadowRadius = 5
    }

    //Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextView = context.nextFocusedView as? UICollectionViewCell {

            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.3,
                           options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                nextView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.layer.shadowColor = UIColor.clear.cgColor
            }, completion: nil)
        }

        if let previousView = context.previouslyFocusedView as? UICollectionViewCell {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.5,
                           options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                previousView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layer.shadowColor = UIColor.black.cgColor
            }, completion: nil)
        }
    }
}
