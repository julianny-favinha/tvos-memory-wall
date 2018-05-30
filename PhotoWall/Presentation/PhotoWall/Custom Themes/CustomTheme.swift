//
//  CustomTheme.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

class CustomTheme: PhotoWallTheme {
    var placeholder: UIImage
    var backgroundColor: UIColor
    var collectionViewLayout: CustomLayout
    var processor: ImageProcessor
    var backgroundView: UIView?
    var cellIdentifier: String
    
    init(placeholder: UIImage, backgroundColor: UIColor,
         layout: CustomLayout, processor: ImageProcessor,
         background: UIView?, cellID: String) {
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.collectionViewLayout = layout
        self.processor = processor
        self.backgroundView = background
        self.cellIdentifier = cellID
    }
    
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView,
                    with photo: Photo) -> ImageCollectionViewCell {
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as?
            ImageCollectionViewCell else {
                return ImageCollectionViewCell()
        }
        
        return cell
    }
    
    func transitionToSelectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 20
            cell.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    func transitionToUnselectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 5
            cell.layer.shadowColor = UIColor.black.cgColor
        }
    }
}
