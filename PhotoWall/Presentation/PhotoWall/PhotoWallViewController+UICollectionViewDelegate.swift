//
//  PhotoWallViewController+UICollectionViewDelegate.swift
//  photo-wall
//
//  Created by Thales - Bepid on 23/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit

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
        
        if shouldStopMoving {
            shouldStopMoving = false
            // Unselected cell
            if let indexPath = context.nextFocusedIndexPath {
                if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                    theme.transitionToUnselectedState(cell: cell)
                }
            }
            return
        }
        
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
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        self.shouldStopMoving = true
        return collectionView.indexPathsForVisibleItems.last
    }
    
    /// Restart animation
    /// If the collection view scrolled *automatically* to the last image
    ///
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Get More URLs
        if indexPath.row > collectionView.numberOfItems(inSection: 0) - imageTreshold &&
            !isUpdatingImages {
            print("UPDATING IMAGES")
            isUpdatingImages = true
            // Updating images
            photosServices.getPhotosFromSelectedAlbuns(options: .nextImages) { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        print("Reload Data")
                        self.collectionView.reloadData()
                        self.isUpdatingImages = false
                    }
                }
            }
        }
    }
}
