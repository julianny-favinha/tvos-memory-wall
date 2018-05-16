//
//  PhotosServices.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/10/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class PhotosServices {
    
    let facebookMechanism: FacebookMechanism = FacebookMechanism()
    
    let facebookAlbunsID: [Int] = []

    func getPhotos(completion: (([Photo], Error?) -> Void)?) {
        DispatchQueue.global().async {
            
            // TODO: get tagged photos
            let graphPath = "me/photos/?limit=30&type=uploaded"
            let parameters: [String] = ["source", "name", "width", "height", "created_time"]
            var requestError: Error?
            var photos: [Photo] = []
            
            do {
                photos = try self.facebookMechanism.executePhotosRequest(graphPath: graphPath,
                                                                         parameters: parameters,
                                                                         options: .nextImages)
            } catch {
                requestError = error
            }
            
            // Execute completion handler
            completion?(photos, requestError)
        }
    }
    
    // Get all user albums
    func updateFacebookAlbuns(completion: (([Album], Error?) -> Void)?) {
        DispatchQueue.global().async {
            var albums: [Album] = []
            var requestError: Error?
            
            do {
                albums = try self.facebookMechanism.getUserAlbuns()
            } catch {
                requestError = error
            }
            completion?(albums, requestError)
        }
    }
}
