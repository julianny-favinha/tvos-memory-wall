//
//  ThemeCustomization.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
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
}

enum Layouts: String {
    case singleLine = "Single Line"
    case twoLines = "Two Lines"
}

enum Cells: String {
    case simple = "Simple"
    case polaroid = "Polaroid"
    case blackWhite = "Black And White"
}


class ThemeCustomization {
    
    
    // Backgrounds
    static let backgrounds: [Backgrounds] =
        [.light, .lightPink, .lightBlue, .confetti, .dark, .darkGray]
    
    static let backgroundImage: [Backgrounds: UIImage] =
        [.light: #imageLiteral(resourceName: "partyThemeImage"), .lightPink: #imageLiteral(resourceName: "partyThemeImage"), .lightBlue: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg"), .confetti: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg"), .dark: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg"), .darkGray: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg")]
    
    static let backgroundColors: [Backgrounds: UIColor] =
        [.light: UIColor.white, .lightPink: #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 0.1993792808), .lightBlue: #colorLiteral(red: 0.5079426765, green: 0.8540073037, blue: 0.9591421485, alpha: 0.4952108305), .confetti: .clear,
         .dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7), .darkGray: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    static let backgroundViews: [Backgrounds: UIView] = [.confetti: ConfettiView()]
    
    
    
    
    // Layouts
    static let layouts: [Layouts] =
        [.singleLine, .twoLines]
    
    static let layoutImages: [Layouts: UIImage] =
        [.singleLine: #imageLiteral(resourceName: "kyle-nieber-632062-unsplash.jpg"), .twoLines: #imageLiteral(resourceName: "pbThemeImage")]
    
    static let layoutLayouts: [Layouts: CustomLayout] =
        [.singleLine: DefaultLayout(), .twoLines: LinedGridLayout(numberOfLines: 2)]
    
    
    
    
    // Cells
    static let cells: [Cells] =
        [.simple, .polaroid, .blackWhite]
    
    static let cellsImages: [Cells: UIImage] =
        [.simple: #imageLiteral(resourceName: "whiteThemeImage"), .polaroid: #imageLiteral(resourceName: "pinThemeImage"), .blackWhite: #imageLiteral(resourceName: "pbThemeImage")]
    
    static let cellProcessor: [Cells: ImageProcessor] =
        [.simple: DefaultImageProcessor(), .polaroid: DefaultImageProcessor(),
         .blackWhite: BlackWhiteProcessor()]
    
    
}
