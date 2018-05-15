//
//  ImageModel.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class ImageModel {
    static let photos: [Photo] = [
                                    Photo(idPhoto: "1", name: "Cosmic Timetraveler by Unsplash",
                                          source: Bundle.main.url(forResource: "cosmic-timetraveler-19924-unsplash",
                                                                  withExtension: "jpg")!,
                                          width: 5984, height: 3979),
                                    Photo(idPhoto: "2", name: "Pablo Garcia Saldana by Unsplash",
                                          source: Bundle.main.url(forResource: "pablo-garcia-saldana-33114-unsplash",
                                                                  withExtension: "jpg")!,
                                          width: 5760, height: 3840),
                                    Photo(idPhoto: "4", name: "Pascal DeBrunner by Unsplash",
                                          source: Bundle.main.url(forResource: "pascal-debrunner-634122-unsplash",
                                                                  withExtension: "jpg")!,
                                          width: 5472, height: 3648),
                                    Photo(idPhoto: "5", name: "Forrest Cavale by Unsplash",
                                          source: Bundle.main.url(forResource: "forrest-cavale-353-unsplash",
                                                                  withExtension: "jpg")!,
                                          width: 6016, height: 3376),
                                    Photo(idPhoto: "6", name: "Ryan Schroeder by Unsplash",
                                          source: Bundle.main.url(forResource: "ryan-schroeder-328-unsplash",
                                                                  withExtension: "jpg")!,
                                          width: 4442, height: 2961)]

    static var counter: Int = 0

    class func getNextPhotoURL() -> URL {
        counter += 1
        return photos[counter % photos.count].source
    }
}
