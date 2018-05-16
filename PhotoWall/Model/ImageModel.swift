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
    var photos: [Photo] = []
    var counter: Int = 0
    
    /// Create ImageModel object
    init(json: JSON, category: CategoryPhotos) {
        // parsear json e colocar no array photos
    }

    func getNextPhotoURL() -> URL {
        counter += 1
        return photos[counter % photos.count].source
    }
}
