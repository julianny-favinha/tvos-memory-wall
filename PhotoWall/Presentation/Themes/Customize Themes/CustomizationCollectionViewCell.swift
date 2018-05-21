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
        self.layer.cornerRadius = 20
    }
    
    //Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let cell = context.nextFocusedView as? UICollectionViewCell {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.7401273545)
            }, completion: nil)
        }
        
        if let cell = context.previouslyFocusedView as? UICollectionViewCell {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.backgroundColor = .clear
            }, completion: nil)
        }
    }
}
