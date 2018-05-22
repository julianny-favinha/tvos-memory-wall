//
//  ThemeCollectionViewCell.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: ImageCollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    //Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let cell = context.nextFocusedView as? UICollectionViewCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.layer.shadowOpacity = 0.5
                self.layer.shadowRadius = 10
            }, completion: nil)
        }
        
        if let cell = context.previouslyFocusedView as? UICollectionViewCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layer.shadowOpacity = 0.3
                self.layer.shadowRadius = 5
            }, completion: nil)
        }
    }
}
