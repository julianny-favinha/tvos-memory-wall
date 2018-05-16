//
//  ImageModel.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import SwiftyJSON

class ImageModel {
    static var photos: [Photo] = []
    static var counter: Int = 0
    
    /// Create ImageModel object
//    init(json: JSON) {
//        // parsear json e colocar no array photos
//    }

    class func getNextPhotoURL() -> URL {
        counter += 1
        return photos[counter % photos.count].source
    }
}
