//
//  Cells.swift
//  photo-wall
//
//  Created by Thales - Bepid on 23/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

enum Cells: String {
    case simple = "Simple"
    case polaroid = "Polaroid"
    case blackWhite = "Black And White"
    case framed = "Framed"
    
    static let all: [Cells] =
        [.simple, .polaroid, .blackWhite, .framed]
    
    static let images: [Cells: UIImage] =
        [.simple: #imageLiteral(resourceName: "whiteThemeImage"), .polaroid: #imageLiteral(resourceName: "pinThemeImage"), .blackWhite: #imageLiteral(resourceName: "pbThemeImage")]
    
    static let processor: [Cells: ImageProcessor] =
        [.simple: DefaultImageProcessor(),
         .polaroid: DefaultImageProcessor(),
         .blackWhite: BlackWhiteProcessor()]
    
    static let identifier: [Cells: String] =
        [.simple: "ImageCollectionViewCell",
         .polaroid: "PolaroidCollectionViewCell",
         .blackWhite: "ImageCollectionViewCell",
         .framed: "FramedCollectionViewCell"]
}
