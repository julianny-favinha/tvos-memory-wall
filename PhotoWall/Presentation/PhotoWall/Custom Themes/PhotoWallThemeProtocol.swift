//
//  PhotoWallThemeProtocol.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoWallTheme: class {
    var placeholder: UIImage { get }
    var backgroundColor: UIColor { get }
    var collectionViewLayout: UICollectionViewLayout { get }
    var processor: ImageProcessor { get }
    var backgroundView: UIView? { get }
    
    // Theme Cell
    func createCell(for indexPath: IndexPath,
                    from collectionView: UICollectionView, with photo: Photo) -> ImageCollectionViewCell
    
    // Cell selection animation
    func transitionToUnselectedState(cell: UICollectionViewCell)
    func transitionToSelectedState(cell: UICollectionViewCell)
}

// Default Methods
extension PhotoWallTheme {
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView,
                    with photo: Photo) -> ImageCollectionViewCell {
        
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as?
            ImageCollectionViewCell else {
                return ImageCollectionViewCell()
        }
        return cell
    }
    
    // Default selection animation
    func transitionToSelectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.3,
                       options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        cell.layer.shadowOpacity = 0.7
                        cell.layer.shadowRadius = 20
                        cell.layer.shadowColor = UIColor.black.cgColor
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
