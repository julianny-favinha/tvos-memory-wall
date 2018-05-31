//
//  PhotoWallViewController+UICollectionViewDataSource.swift
//  photo-wall
//
//  Created by Thales - Bepid on 23/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit

extension PhotoWallViewController: UICollectionViewDataSource {
    @objc func scrollCollectionView() {
        scrollAmount += scrollSpeed
        self.collectionView?.contentOffset = CGPoint(x: scrollAmount, y: 0.0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    private func definePlaceholder(width: Int, height: Int) -> UIImage {
        if height > width {
            return #imageLiteral(resourceName: "placeholder2")
        }
        
        return #imageLiteral(resourceName: "placeholder1")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get cell of the current theme
        var cell = ImageCollectionViewCell()
        
        if indexPath.row >= self.photos.count {
            return cell
        }
        
        // Change placeholder
        theme.placeholder = definePlaceholder(width: self.photos[indexPath.row].width,
                                              height: self.photos[indexPath.row].height)
        
        // Create cell
        cell = theme.createCell(for: indexPath, from:
            collectionView, with: self.photos[indexPath.row])
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: self.photos[indexPath.row].source,
            placeholder: theme.placeholder,
            options: [.processor(theme.processor)],
            progressBlock: nil, completionHandler: nil)
        
        return cell
    }
}
