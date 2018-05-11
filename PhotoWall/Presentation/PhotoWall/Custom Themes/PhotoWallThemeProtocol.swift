//
//  PhotoWallThemeProtocol.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

protocol PhotoWallTheme: class {
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView) -> PhotoCell
}

// Default Methods
extension PhotoWallTheme {
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView) -> PhotoCell {
        
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as?
            ImageCollectionViewCell else {
                return PhotoCell()
        }
        return cell
    }
}
