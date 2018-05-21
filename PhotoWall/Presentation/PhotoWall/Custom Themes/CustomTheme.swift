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
    
    let cellDict: [String: String] = ["Simple": "imageCell",
                                      "Polaroid": "polaroidCell",
                                      "Black And White": "imageCell"]
    
    var placeholder: UIImage
    var backgroundColor: UIColor
    var collectionViewLayout: UICollectionViewLayout
    var processor: ImageProcessor
    var backgroundView: UIView?
    var cellType: String
    
    init(placeholder: UIImage, backgroundColor: UIColor,
         layout: UICollectionViewLayout, processor: ImageProcessor,
         background: UIView?, photo: String) {
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.collectionViewLayout = layout
        self.processor = processor
        self.backgroundView = background
        
        self.cellType = photo
    }
    
    func createCell(for indexPath: IndexPath, from collectionView: UICollectionView,
                    with photo: Photo) -> ImageCollectionViewCell {
        
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellDict[cellType]!, for: indexPath) as?
            ImageCollectionViewCell else {
                return ImageCollectionViewCell()
        }
        return cell
    }
}
