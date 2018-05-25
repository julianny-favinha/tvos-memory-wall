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
}
