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
    case numberOfThemes
    case userThemes
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
    
    /// Save a dictionary with the user Facebook Albuns
    ///
    /// - Parameter albums: the dictionary to be saved
    class func saveFacebookAlbuns(albums: [String: Bool]) {
        defaults.set(albums, forKey: UserDefaultsKeys.facebookAlbuns.rawValue)
    }
    
    /// Retrieve from UserDefaults the user selected Facebook Albuns
    /// as a disctionary of [String: Bool]
    /// where the key is the Album ID
    /// and the value tells if the user selected that album or not
    ///
    /// - Returns: the dictionary
    class func getFacebookAlbuns() -> [String: Bool] {
        if let array = defaults.dictionary(forKey: UserDefaultsKeys.facebookAlbuns.rawValue) as? [String: Bool] {
            return array
        }
        return [:]
    }
    
    /// Add a new userTheme to the User Defaults
    /// Encode the UserTheme object and store it as a data Object
    /// inde a dictionary referenced by its "name" as the key
    ///
    /// - Parameter theme: the new user theme to be saved
    class func addUserTheme(_ theme: UserTheme) {
        var dict = self.getUserThemes()
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: theme)
        dict.merge([theme.name: encodedData], uniquingKeysWith: { (_, second) -> Data in
            return second
        })
        defaults.set(dict, forKey: UserDefaultsKeys.userThemes.rawValue)
    }
    
    /// remove a User Theme from the defaults
    class func removeUserTheme(with name: String) {
        var dict = defaults.dictionary(forKey: UserDefaultsKeys.userThemes.rawValue)
        dict?.removeValue(forKey: name)
        defaults.set(dict, forKey: UserDefaultsKeys.userThemes.rawValue)
    }
    
    /// Retrieve the User Themes from the UserDefaults
    /// it will bring the data as a Data object
    ///
    /// - Returns: the dictionary with the stored information
    class func getUserThemes() -> [String: Data] {
        if let dict = defaults.dictionary(forKey: UserDefaultsKeys.userThemes.rawValue) as? [String: Data] {
            return dict
        }
        return [:]
    }
    
    /// Retrieve the User Theme as a dictionary of [String: UserTheme]
    /// the key is the name of the UserTheme
    ///
    /// - Returns: the dictionary
    class func getDecodedUserThemes() -> [String: UserTheme] {
        var dict: [String: UserTheme] = [:]
        for (name, data) in getUserThemes() {
            // swiftlint:disable force_cast
            let decoded = NSKeyedUnarchiver.unarchiveObject(with: data) as! UserTheme
            dict.merge([name: decoded]) { (_, theme) -> UserTheme in
                return theme
            }
            // swiftlint:enable force_cast
        }
        return dict
    }
    
    class func getNumberOfThemes() -> Int {
        return defaults.integer(forKey: UserDefaultsKeys.numberOfThemes.rawValue)
    }
    
    class func updateNumberOfThemes() {
        let amount = getNumberOfThemes()
        defaults.set(amount + 1, forKey: UserDefaultsKeys.numberOfThemes.rawValue)
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
