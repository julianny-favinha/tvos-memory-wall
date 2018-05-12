//
//  ThemeReference.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

enum Theme: String {
    case defaultTheme
    case pinTheme
    case darkTheme
    
    static func getTheme(from rawValue: String) -> Theme {
        switch rawValue {
        case "pinTheme":
            return .pinTheme
        case "darkTheme":
            return .darkTheme
        default:
            return .defaultTheme
        }
    }
}

class PhotoWallThemes {
    // The name of the Theme
    static let themes: [Theme] = [.defaultTheme, .pinTheme, .darkTheme]
    static let themeName: [String] = ["Regular Theme", "Photo Pin Theme", "Dark Theme"]
    
    // The dictionary for theme instantiation
    static let themeDict: [Theme: PhotoWallTheme] =
        [.defaultTheme: DefaultTheme(),
         .pinTheme: PhotoPinTheme(),
         .darkTheme: DarkTheme()]
}
