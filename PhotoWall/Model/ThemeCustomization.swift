//
//  ThemeCustomization.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

enum Backgrounds: String {
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
        [.lightPink, .lightBlue, .confetti, .dark, .darkGray]
    
    static let backgroundImage: [Backgrounds: UIImage] =
        [.lightPink: #imageLiteral(resourceName: "partyThemeImage"), .lightBlue: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg"), .confetti: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg"), .dark: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg"), .darkGray: #imageLiteral(resourceName: "casey-horner-487085-unsplash.jpg")]
    
    // Layouts
    static let layouts: [Layouts] =
        [.singleLine, .twoLines]
    
    static let layoutImages: [Layouts: UIImage] =
        [.singleLine: #imageLiteral(resourceName: "kyle-nieber-632062-unsplash.jpg"), .twoLines: #imageLiteral(resourceName: "pbThemeImage")]
    
    // Cells
    static let cells: [Cells] =
        [.simple, .polaroid, .blackWhite]
    
    static let cellsImages: [Cells: UIImage] =
        [.simple: #imageLiteral(resourceName: "whiteThemeImage"), .polaroid: #imageLiteral(resourceName: "pinThemeImage"), .blackWhite: #imageLiteral(resourceName: "pbThemeImage")]
    
    
}
