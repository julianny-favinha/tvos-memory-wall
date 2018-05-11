//
//  PhotoWallThemeProtocol.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

protocol PhotoWallTheme: class {
    
    var placeholder: UIImage { get }
    var backgroundColor: UIColor { get }
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView) -> ImageCollectionViewCell
}

// Default Methods
extension PhotoWallTheme {
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView) -> ImageCollectionViewCell {
        
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as?
            ImageCollectionViewCell else {
                return ImageCollectionViewCell()
        }
        return cell
    }
}
