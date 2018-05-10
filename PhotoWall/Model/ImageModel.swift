//
//  ImageModel.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class ImageModel {
    static let images: [UIImage] = [#imageLiteral(resourceName: "IM01"), #imageLiteral(resourceName: "IM02"), #imageLiteral(resourceName: "IM03"), #imageLiteral(resourceName: "IM04"), #imageLiteral(resourceName: "IM05"), #imageLiteral(resourceName: "IM06")]
    static var counter: Int = 0

    class func getNetImage() -> UIImage {
        counter += 1
        return images[counter % images.count]
    }
}
