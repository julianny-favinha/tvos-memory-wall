//
//  ImageCollectionViewCell.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Properties
    var theme: PhotoWallTheme?

    // MARK: - Life cycle
    
    //Animate views according to focus engine changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextView = context.nextFocusedView as? UICollectionViewCell {
            theme?.transitionToSelectedState(cell: nextView)
        }
        
        if let previousView = context.previouslyFocusedView as? UICollectionViewCell {
            theme?.transitionToUnselectedState(cell: previousView)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 4, height: 6)
        self.layer.shadowRadius = 5
    }
}
