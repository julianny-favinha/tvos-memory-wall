//
//  UserTheme.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

// Object to be saved on UserDefaults
class UserTheme: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(layout, forKey: "layout")
        aCoder.encode(background, forKey: "background")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // swiftlint:disable force_cast
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let photo = aDecoder.decodeObject(forKey: "photo") as! String
        let layout = aDecoder.decodeObject(forKey: "layout") as! String
        let background = aDecoder.decodeObject(forKey: "background") as! String
        self.init(name: name, photo: photo, layout: layout, background: background)
        // swiftlint:enable force_cast
    }
    
    var name: String
    var photo: String
    var layout: String
    var background: String
    
    init(name: String, photo: String, layout: String, background: String) {
        self.name = name
        self.photo = photo
        self.layout = layout
        self.background = background
    }
    
    func createCustomTheme() -> CustomTheme {
        
        let back = Backgrounds(rawValue: background)!
        let phot = Cells(rawValue: photo)!
        let lay = Layouts(rawValue: layout)!
        
        return CustomTheme(placeholder: #imageLiteral(resourceName: "placeholder"),
                           backgroundColor: ThemeCustomization.backgroundColors[back]!,
                           layout: ThemeCustomization.layoutLayouts[lay]!,
                           processor: ThemeCustomization.cellProcessor[phot]!,
                           background: ThemeCustomization.backgroundViews[back])
    }
}
