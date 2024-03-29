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
    var facebookAlbums: [Album] = []

    /// Get photos from selected albums
    ///
    /// - Parameter completion: completion handler (receveid photos)
    func getPhotosFromSelectedAlbuns(options: PhotoRequestOptions, completion: (([Photo], Error?) -> Void)?) {
        self.updateFacebookAlbuns { (albums, error) in
            self.facebookAlbums = albums
            
            // Load from User Defaults
            let dict = UserDefaultsManager.getFacebookAlbuns()
            
            var photos: [Photo] = []
            var requestError: Error?
            
            // Get Photos for each album ID
            DispatchQueue.global().async {
                for (albumID, selected) in dict where selected == true {
                    var result: [Photo] = []
                    do {
                        result = try self.facebookMechanism.getAlbumPictures(from: albumID, options: options)
                    } catch {
                        requestError = error
                    }
                    photos.append(contentsOf: result)
                }
                
                // Run Completion
                completion?(photos.shuffled(), requestError)
            }
        }
    }
    
    /// Get facebook albums
    ///
    /// - Parameter completion: completion handler (received albums)
    func updateFacebookAlbuns(completion: (([Album], Error?) -> Void)?) {
        DispatchQueue.global().async {
            var albums: [Album] = []
            var requestError: Error?
            
            do {
                albums = try self.facebookMechanism.getUserAlbums()
            } catch {
                requestError = error
            }
            
            // Make dictionary for albums
            var albumDict: [String: Bool] = [:]
            for album in albums {
                albumDict.merge(["\(album.idAlbum)": true], uniquingKeysWith: { (_, _) -> Bool in
                    return true
                })
            }
            
            // Save on User Defaults and on static reference
            let oldDict = UserDefaultsManager.getFacebookAlbuns()
            let newDict = albumDict.merging(oldDict, uniquingKeysWith: { (bool1, bool2) -> Bool in
                return bool1 && bool2
            })
            UserDefaultsManager.saveFacebookAlbuns(albums: newDict)
            completion?(albums, requestError)
        }
    }
    
    /// Get photos from all albums
    ///
    /// - Parameter completion: completion handler (received photos)
    func getPhotosForAllAlbuns(completion: (([Photo], Error?) -> Void)?) {
        self.updateFacebookAlbuns { (albums, _) in
            self.facebookAlbums = albums

            // Load from User Defaults
            let dict = UserDefaultsManager.getFacebookAlbuns()
            
            var photos: [Photo] = []
            var requestError: Error?
            
            // Get Photos for each album ID
            DispatchQueue.global().async {
                for (albumID, _) in dict {
                    var result: [Photo] = []
                    do {
                        result = try self.facebookMechanism.getAlbumPictures(from: albumID, options: .fromBegining)
                        for album in self.facebookAlbums where album.idAlbum == albumID {
                            album.photos = result
                        }
                    } catch {
                        requestError = error
                    }
                    photos.append(contentsOf: result)
                }
                
                // Save on static member
                FacebookAlbumReference.albums = self.facebookAlbums
                
                // Run Completion
                completion?(photos.shuffled(), requestError)
            }
        }
    }
}
