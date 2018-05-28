//
//  PhotoWallViewController+CustomLayoutDelegate.swift
//  photo-wall
//
//  Created by Thales - Bepid on 23/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

// PhotoWallViewController implementation of the CustomLayoutDelegate protocol
extension PhotoWallViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= photos.count {
            return 100
        }
        return CGFloat(photos[indexPath.item].height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= photos.count {
            return 100
        }
        return CGFloat(photos[indexPath.item].width)
    }
}
