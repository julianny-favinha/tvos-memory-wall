//
//  DefaultTheme.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

class DarkTheme: PhotoWallTheme {
    var placeholder: UIImage = #imageLiteral(resourceName: "placeholder1")
    var backgroundColor: UIColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
    var collectionViewLayout: CustomLayout = DefaultLayout()
    var processor: ImageProcessor = DefaultImageProcessor()
    var backgroundView: UIView?
    
    // Define the image selected color
    let selectedHighlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    func transitionToSelectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.3,
                       options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        cell.layer.shadowOpacity = 0.7
                        cell.layer.shadowRadius = 20
                        cell.layer.shadowColor = self.selectedHighlightColor.cgColor
        }, completion: nil)
    }

    func transitionToUnselectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        cell.layer.shadowOpacity = 0.3
                        cell.layer.shadowRadius = 5
                        cell.layer.shadowColor = UIColor.black.cgColor
        }, completion: nil)
    }
}
