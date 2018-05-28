//
//  PhotoWallViewController+UICollectionViewDelegate.swift
//  photo-wall
//
//  Created by Thales - Bepid on 23/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

extension PhotoWallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Allows every cell to be selectable
    /// if false: the cell cannot be clicked
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Allows every cell to be focusable
    /// if false: the current cell will be selected using the remote
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Select a collectionView item
    /// using siri-remote click
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView
    ///   - indexPath: the selected indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            self.selectedIndexPath = indexPath
            self.popUpImage(image: cell.imageView.image!)
        }
    }
    
    /// Coordinate the change of focus inside the collection view
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView
    ///   - context: the current focus context
    ///   - coordinator: the animation coordinator
    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        // Selected cell
        if let indexPath = context.nextFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                theme.transitionToSelectedState(cell: cell)
            }
        }
        // Unselected cell
        if let indexPath = context.previouslyFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                theme.transitionToUnselectedState(cell: cell)
            }
        }
        stopMoving()
    }
    
    /// Restart animation
    /// If the collection view scrolled *automatically* to the last image
    ///
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Last cell left the screen on automatic scroll mode
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 &&
            isRunning == true {
            UIView.animate(withDuration: 1) {
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
                self.scrollAmount = 0
            }
        }
        
        // Get More URLs
        if indexPath.row > collectionView.numberOfItems(inSection: 0) - imageTreshold &&
            !isUpdatingImages {
            isUpdatingImages = true
            // Updating images
            photosServices.getPhotosFromSelectedAlbuns(options: .nextImages) { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        self.collectionView.collectionViewLayout.invalidateLayout()
                        self.collectionView.reloadData()
                    }
                }
                self.isUpdatingImages = false
            }
        }
    }
}
