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
        self.imageView.layer.cornerRadius = 20
        self.imageView.clipsToBounds = true
    }
    
    //Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let cell = context.nextFocusedView as? UICollectionViewCell {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.3,
                           options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                cell.layer.shadowOpacity = 0.5
                cell.layer.shadowRadius = 7
                cell.layer.shadowColor = UIColor.blue.cgColor
            }, completion: nil)
        }
        
        if let cell = context.previouslyFocusedView as? UICollectionViewCell {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.3,
                           options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.layer.shadowColor = UIColor.clear.cgColor
            }, completion: nil)
        }
    }
}
