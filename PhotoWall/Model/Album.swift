//
//  Album.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 16/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

class Album {
    
    var idAlbum: String
    var name: String
    var date: Date
    
    init(idAlbum: String, name: String, date: Date) {
        self.idAlbum = idAlbum
        self.name = name
        self.date = date
    }
    
}

class FacebookAlbumReference {
    static var albuns: [Album] = []
}
