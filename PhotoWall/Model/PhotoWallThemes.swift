//
//  ThemeReference.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

enum Theme: String {
    case defaultTheme
    case pinTheme
    case darkTheme
    case blackAndWhiteGrid
}

class PhotoWallThemes {
    // The name of the Theme
    static let themes: [Theme] = [.defaultTheme, .pinTheme,
                                  .darkTheme, .blackAndWhiteGrid]
    
    static let themeName: [Theme: String] = [.defaultTheme: "Light Theme",
                                             .pinTheme: "Photo Pin Theme",
                                             .darkTheme: "Dark Theme",
                                             .blackAndWhiteGrid: "Black and White Grid"]
    
    static let themeImage: [Theme: UIImage] = [.defaultTheme: #imageLiteral(resourceName: "whiteThemeImage"),
                                               .pinTheme: #imageLiteral(resourceName: "pinThemeImage"),
                                               .darkTheme: #imageLiteral(resourceName: "darkThemeImage"),
                                               .blackAndWhiteGrid: #imageLiteral(resourceName: "darkThemeImage")]
    
    // The dictionary for theme instantiation
    static let themeDict: [Theme: PhotoWallTheme] =
        [.defaultTheme: DefaultTheme(),
         .pinTheme: PhotoPinTheme(),
         .darkTheme: DarkTheme(),
         .blackAndWhiteGrid: BlackAndWhiteGridTheme()]
}
