//
//  Photo.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/11/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class Photo {
    var idPhoto: String
    var name: String?
    var source: URL
    var width: Int
    var height: Int
    var size: CGSize
    var date: Date?
    
    /// Create Photo object without Date
    init(idPhoto: String, name: String?, source: URL, width: Int, height: Int) {
        self.idPhoto = idPhoto
        self.name = name
        self.source = source
        self.width = width
        self.height = height
        self.size = CGSize(width: width, height: height)
    }
    
    /// Create Photo object with Date
    init(idPhoto: String, name: String?, source: URL, width: Int, height: Int, date: Date?) {
        self.idPhoto = idPhoto
        self.name = name
        self.source = source
        self.width = width
        self.height = height
        self.date = date
        self.size = CGSize(width: width, height: height)
    }
}
