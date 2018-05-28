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
    case blue = "Blue Enhancement"
    case saturation = "High Saturation"
    
    static let all: [Cells] = [
        .simple,
        .polaroid,
        .blackWhite,
        .framed,
        .blue,
        .saturation
    ]
    
    static let images: [Cells: UIImage] = [
        .simple: #imageLiteral(resourceName: "simple"),
        .polaroid: #imageLiteral(resourceName: "pinThemeImage"),
        .blackWhite: #imageLiteral(resourceName: "blackAndWhite"),
        .framed: #imageLiteral(resourceName: "framed"),
        .blue: #imageLiteral(resourceName: "blueEnhancement"),
        .saturation: #imageLiteral(resourceName: "saturation")
    ]
    
    static let processor: [Cells: ImageProcessor] = [
        .simple: DefaultImageProcessor(),
        .polaroid: DefaultImageProcessor(),
        .blackWhite: BlackWhiteProcessor(),
        .framed: DefaultImageProcessor(),
        .blue: OverlayImageProcessor(overlay: .blue, fraction: 0.9),
        .saturation: ColorControlsProcessor(brightness: 0.0, contrast: 1.0, saturation: 2.0, inputEV: 0.7)
    ]
    
    static let identifier: [Cells: String] = [
        .simple: "ImageCollectionViewCell",
        .polaroid: "PolaroidCollectionViewCell",
        .blackWhite: "ImageCollectionViewCell",
        .framed: "FramedCollectionViewCell",
        .blue: "ImageCollectionViewCell",
        .saturation: "ImageCollectionViewCell"
    ]
    
    static let padding: [Cells: (vertical: CGFloat, horizontal: CGFloat)] = [
        .blackWhite: (vertical: 20, horizontal: 20),
        .simple: (vertical: 20, horizontal: 20),
        .framed: (vertical: 30, horizontal: 30),
        .polaroid: (vertical: 30, horizontal: 30),
        .blue: (vertical: 20, horizontal: 20),
        .saturation: (vertical: 20, horizontal: 20)
    ]
}
