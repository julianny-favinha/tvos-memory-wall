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
    
    /// Create ImageModel object
    init(json: JSON, categories: [CategoryPhotos]) {
        // parsear json e colocar no array photos
        for category in categories {
            for image in json[category.rawValue]["images"] {
                let data = image.1
                photos.append(Photo(idPhoto: data["id"].rawString()!,
                                    name: data["name"].rawString()!,
                                    source: Bundle.main.url(forResource: data["filename"].rawString()!,
                                                            withExtension: "jpg")!,
                                    width: Int(data["width"].rawString()!)!,
                                    height: Int(data["height"].rawString()!)!
                ))
            }
        }
        photos.shuffle()
    }

    func getNextPhotoURL(for indexPath: IndexPath) -> URL {
        return photos[indexPath.row % photos.count].source
    }
}
