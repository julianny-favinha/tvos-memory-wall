//
//  Backgrounds.swift
//  photo-wall
//
//  Created by Thales - Bepid on 23/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

enum Backgrounds: String {
    case light = "Light"
    case lightPink = "Light Pink"
    case lightBlue = "Light Blue"
    case confetti = "Confetti"
    case dark = "Dark"
    case darkGray = "Dark Gray"
    case beach = "Beach"
    case woodWall = "Wood Wall"
    case cork = "Cork"
    
    
    static let all: [Backgrounds] =
        [.light, .lightPink, .lightBlue, .confetti, .dark, .darkGray, .beach, .woodWall, .cork]
    
    static let images: [Backgrounds: UIImage] =
        [.light: #imageLiteral(resourceName: "light"), .lightPink: #imageLiteral(resourceName: "lightPink"), .lightBlue: #imageLiteral(resourceName: "lightBlue"), .confetti: #imageLiteral(resourceName: "confetti2"), .dark: #imageLiteral(resourceName: "dark"), .darkGray: #imageLiteral(resourceName: "darkGray"),
         .beach: #imageLiteral(resourceName: "beach.gif"), .woodWall: #imageLiteral(resourceName: "woodWall"), .cork: #imageLiteral(resourceName: "cork")]
    
    static let colors: [Backgrounds: UIColor] =
        [.light: .clear, .lightPink: #colorLiteral(red: 1, green: 0.5411764706, blue: 0.8470588235, alpha: 0.1993792808), .lightBlue: #colorLiteral(red: 0.5098039216, green: 0.8549019608, blue: 0.9607843137, alpha: 0.4952108305), .confetti: .clear,
         .dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7), .darkGray: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), .beach: .clear, .woodWall: .clear, .cork: .clear]
    
    static let views: [Backgrounds: UIView?] =
        [.light: nil, .lightPink: nil, .lightBlue: nil,
         .dark: nil, .darkGray: nil, .confetti: ConfettiView(),
         .beach: GIFBackground(image: "beach", ext: "gif"), .woodWall: BackgroundImageView(image: #imageLiteral(resourceName: "woodWall")),
         .cork: BackgroundImageView(image: #imageLiteral(resourceName: "cork"))]
}
