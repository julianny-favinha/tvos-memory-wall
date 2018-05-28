//
//  Layouts.swift
//  photo-wall
//
//  Created by Thales - Bepid on 23/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

enum Layouts: String {
    case singleLine = "Single Line"
    case twoLines = "Two Lines"
    case singleImage = "Single Image"
    case threeLines = "Three Lines"
    case smallImages = "Small Images"
    
    static let all: [Layouts] = [
        .singleLine,
        .twoLines,
        .singleImage,
        .threeLines,
        .smallImages
    ]
    
    static let images: [Layouts: UIImage] = [
        .singleLine: #imageLiteral(resourceName: "oneLine"),
        .twoLines: #imageLiteral(resourceName: "twoLines"),
        .singleImage: #imageLiteral(resourceName: "singleImage"),
        .threeLines: #imageLiteral(resourceName: "threeLines"),
        .smallImages: #imageLiteral(resourceName: "fiveLines")
    ]
    
    static let layouts: [Layouts: CustomLayout] = [
        .singleLine: DefaultLayout(),
        .twoLines: LinedGridLayout(numberOfLines: 2),
        .singleImage: FullScreenLayout(),
        .threeLines: LinedGridLayout(numberOfLines: 3),
        .smallImages: LinedGridLayout(numberOfLines: 5)
    ]
}
