//
//  ThemeManager.swift
//  photo-wall
//
//  Created by Thales - Bepid on 24/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

class ThemeManager {
    var currentTheme: PhotoWallTheme = PhotoPinTheme()
    
    static var shared: ThemeManager = ThemeManager()
    
    private init() {
        self.currentTheme = PhotoWallThemes.themeDict[UserDefaultsManager.getPreferredTheme()]!
    }
}
