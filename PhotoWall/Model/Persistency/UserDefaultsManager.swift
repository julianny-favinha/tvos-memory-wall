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
    case localImages
    case numberOfExecution
    case facebookAlbuns
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
    
    /// Retrieve user preferred theme
    class func getPreferredTheme() -> Theme {
        if let themeRawValue = defaults.string(forKey:
            UserDefaultsKeys.preferredPhotoWallTheme.rawValue) {
            return Theme(rawValue: themeRawValue)!
        }
        
        return Theme.defaultTheme
    }
    
    /// Set local images Dictionary
    class func setSelectedLocalImagesDict(to dict: [String: Bool]) {
        defaults.set(dict, forKey: UserDefaultsKeys.localImages.rawValue)
    }
    
    /// Retrieve local images dictionary
    class func getLocalImagesDict() -> [String: Bool]? {
        if let dict = defaults.dictionary(forKey: UserDefaultsKeys.localImages.rawValue) as? [String: Bool] {
            return dict
        }
        return nil
    }
    
    class func saveFacebookAlbuns(albums: [String: Bool]) {
        defaults.set(albums, forKey: UserDefaultsKeys.facebookAlbuns.rawValue)
    }
    
    class func getFacebookAlbuns() -> [String: Bool] {
        if let array = defaults.dictionary(forKey: UserDefaultsKeys.facebookAlbuns.rawValue) as? [String: Bool] {
            return array
        }
        return [:]
    }
    
    // MARK: numberOfExecutions
    // not used yet
    class func updateNumberOfExecutions() {
        let key = UserDefaultsKeys.numberOfExecution.rawValue
        defaults.set(defaults.integer(forKey: key) + 1, forKey: key)
    }
    
    class func getNumberOfExecutions() -> Int {
        return defaults.integer(forKey: UserDefaultsKeys.numberOfExecution.rawValue)
    }
}
