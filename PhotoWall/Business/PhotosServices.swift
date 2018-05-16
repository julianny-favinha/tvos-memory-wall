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
    var facebookAlbunsID: [String] = []

    func getPhotos(completion: (([Photo], Error?) -> Void)?) {
        
        DispatchQueue.global().async {
            self.updateFacebookAlbuns(completion: nil)
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
    
    func getPhotosFromSelectedAlbuns() {
        // Load from User Defaults
        let dict = UserDefaultsManager.getFacebookAlbuns()
        
        // Load the albuns IDs
        facebookAlbunsID = dict.map({ (dictPart) -> String in
            return dictPart.key
        })
        
        // Check if you have the albuns IDs - fetch it
        if facebookAlbunsID == [] {
            self.updateFacebookAlbuns { (result, _) in
                self.facebookAlbunsID = result.map({ (album) -> String in
                    return album.idAlbum
                })
            }
        }
        
        var photos: [Photo] = []
        // Get Photos for each album ID
        for albumID in facebookAlbunsID {
            DispatchQueue.global().async {
                var result: [Photo] = []
                do {
                    result = try self.facebookMechanism.getAlbumPictures(albumID: albumID)
                } catch {}
                photos.append(contentsOf: result)
            }
        }
        
        // Check for new albuns
        updateFacebookAlbuns(completion: nil)
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
            
            // Make dictionary for albuns
            var albumDict: [String: Bool] = [:]
            for album in albums {
                albumDict.merge(["\(album.idAlbum)": true], uniquingKeysWith: { (_, _) -> Bool in
                    return true
                })
            }
            
            // Save on User Defaults
            UserDefaultsManager.saveFacebookAlbuns(albuns: albumDict)
            
            // DEBUG
            do {
                print(try self.facebookMechanism.getAlbumPictures(albumID: albums[0].idAlbum))
            } catch {}
            
            completion?(albums, requestError)
        }
    }
}
