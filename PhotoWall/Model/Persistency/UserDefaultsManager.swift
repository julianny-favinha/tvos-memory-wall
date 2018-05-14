//
//  UserDefaultsManager.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case preferredPhotoWallTheme
}

class UserDefaultsManager {
    static var defaults = UserDefaults.standard
    
    /// Save the preferred photo wall theme
    /// on UserDefaullts
    ///
    /// - Parameter theme: the user stored theme
    class func setPreferredTheme(to theme: Theme) {
        defaults.set(theme.rawValue, forKey:
            UserDefaultsKeys.preferredPhotoWallTheme.rawValue)
    }
    
    class func getPreferredTheme() -> Theme {
        if let themeRawValue = defaults.string(forKey:
            UserDefaultsKeys.preferredPhotoWallTheme.rawValue) {
            return Theme.getTheme(from: themeRawValue)
        }
        
        return Theme.defaultTheme
    }
}
