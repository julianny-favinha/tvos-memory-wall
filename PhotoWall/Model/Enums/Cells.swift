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
    
    static let all: [Cells] = [
        .simple,
        .polaroid,
        .blackWhite,
        .framed
    ]
    
    static let images: [Cells: UIImage] = [
        .simple: #imageLiteral(resourceName: "simple"),
        .polaroid: #imageLiteral(resourceName: "pinThemeImage"),
        .blackWhite: #imageLiteral(resourceName: "blackAndWhite"),
        .framed: #imageLiteral(resourceName: "framed")
    ]
    
    static let processor: [Cells: ImageProcessor] = [
        .simple: DefaultImageProcessor(),
        .polaroid: DefaultImageProcessor(),
        .blackWhite: BlackWhiteProcessor(),
        .framed: DefaultImageProcessor()
    ]
    
    static let identifier: [Cells: String] = [
        .simple: "ImageCollectionViewCell",
        .polaroid: "PolaroidCollectionViewCell",
        .blackWhite: "ImageCollectionViewCell",
        .framed: "FramedCollectionViewCell"
    ]
    
    static let padding: [Cells: (vertical: CGFloat, horizontal: CGFloat)] = [
        .blackWhite: (vertical: 20, horizontal: 20),
        .simple: (vertical: 20, horizontal: 20),
        .framed: (vertical: 30, horizontal: 30),
        .polaroid: (vertical: 30, horizontal: 30)
    ]
}
