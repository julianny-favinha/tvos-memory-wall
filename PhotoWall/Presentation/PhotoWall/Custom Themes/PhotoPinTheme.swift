//
//  PhotoPinTheme.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class PhotoPinTheme: PhotoWallTheme {
    var placeholder: UIImage = #imageLiteral(resourceName: "placeholder")
    var backgroundColor: UIColor = .clear
    
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView) -> ImageCollectionViewCell {
        
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "photoWithBorderCell", for: indexPath) as?
            ImageCollectionViewCell else {
                return ImageCollectionViewCell()
        }
        return cell
    }
    
}
