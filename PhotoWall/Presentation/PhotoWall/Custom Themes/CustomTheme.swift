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
    var collectionViewLayout: UICollectionViewLayout
    var processor: ImageProcessor
    var backgroundView: UIView?
    
    init(placeholder: UIImage, backgroundColor: UIColor, layout: UICollectionViewLayout, processor: ImageProcessor, background: UIView?) {
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.collectionViewLayout = layout
        self.processor = processor
        self.backgroundView = background
    }
}
