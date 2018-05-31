//
//  FacebookServices.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/10/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import SwiftyJSON

class FacebookMechanism {
    var photoPagingAlbumAfter: [String: String] = [:] // AlbumID: Next
    
    /// Make a Facebook Graph API Request
    /// Sync
    ///
    /// - Parameters:
    ///   - graphPath: the graphPath description (me: profile, me/photos...)
    ///   - parameters: the request fields
    /// - Returns: A [String:Any] dict with the requested fields
    ///            if the field didn't come, the value will be NULL
    /// - Throws: Graph API Request Error
    func executeRequest(graphPath: String, parameters: [String]) throws -> User {
        // Create returning variable
        var user: User!
        
        let convertedParameters: String = createRequestParameters(from: parameters)
        let requestParameters: [NSObject: AnyObject] = ["fields" as NSObject: convertedParameters as AnyObject]
        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: requestParameters)
        
        // Start semaphore
        let semaphore = DispatchSemaphore(value: 0)
        var completionError: Error? = nil
        
        // Make Graph API Request
        _ = graphRequest?.start(completionHandler: { (_, result, error) in
            if let error = error {
                // Add error and releae semaphore
                completionError = error
                semaphore.signal()
            } else {
                user = self.parseJsonOfPublicProfile(result: result)
            }
            // Release semaphore - signal
            semaphore.signal()
        })
        
        // Semaphore Wait
        semaphore.wait()
        
        // Check if the request created an error
        if completionError != nil {
            throw completionError!
        }
        return user
    }
    
    /// Parse JSON of public profile
    ///
    /// - Parameter result: JSON received from requesting public profile
    /// - Returns: User
    private func parseJsonOfPublicProfile(result: Any?) -> User {
        // Convert result into JSON - SwiftyJson library
        let json = JSON(result!)
        
        var userId: String!
        if let idUserString = json["id"].rawString() {
            userId = idUserString
        }
        
        var name: String!
        if let nameString = json["name"].rawString() {
            name = nameString
        }
        
        var firstName: String!
        if let firstNameString = json["first_name"].rawString() {
            firstName = firstNameString
        }
        
        var lastName: String!
        if let lastNameString = json["last_name"].rawString() {
            lastName = lastNameString
        }
        
        let email: String? = json["email"].rawString()
        
        var profilePicture: URL!
        let picture = JSON(json["picture"])
        let data = JSON(picture["data"])
        if let profilePictureString = data["url"].rawString() {
            profilePicture = URL(string: profilePictureString)
        }
        
        return User(uid: userId, name: name, firstName: firstName, lastName: lastName,
                    email: email, profilePicture: profilePicture)
    }

    /// Make a Facebook Graph API Request for Photos
    /// Sync
    ///
    /// - Parameters:
    ///   - graphPath: the graphPath description (me: profile, me/photos...)
    ///   - parameters: the request fields
    /// - Returns: A [String:Any] dict with the requested fields
    ///            if the field didn't come, the value will be NULL
    /// - Throws: Graph API Request Error
    func executePhotosRequest(graphPath: String, parameters: [String],
                              options: PhotoRequestOptions?, albumID: String?) throws -> [Photo] {
        var photos: [Photo] = []
        
        // Get request parameters
        let convertedParameters: String = createRequestParameters(from: parameters)
        let requestParameters: [NSObject: AnyObject] = ["fields" as NSObject: convertedParameters as AnyObject]
        
        // Update the graph path if needed
        var newGraphPath: String = ""
        if let option = options {
            newGraphPath = updateRequestPath(path: graphPath, for: option, with: albumID)
        }

        // Create Request
        let graphRequest = FBSDKGraphRequest(graphPath: newGraphPath, parameters: requestParameters)
        
        // Start semaphore
        let semaphore = DispatchSemaphore(value: 0)
        var completionError: Error? = nil
        
        // Make Graph API Request
        _ = graphRequest?.start(completionHandler: { (_, result, error) in
            if let error = error {
                // Add error and release semaphore
                completionError = error
                semaphore.signal()
            } else {
                // parse Json
                photos = self.parseJsonOfPhotos(result: result, for: albumID)
                
                // Release semaphore - signal
                semaphore.signal()
            }
        })
        
        // Semaphore Wait
        semaphore.wait()
        
        // Check if the request created an error
        if completionError != nil {
            throw completionError!
        }
        
        return photos
    }
    
    /// Parse JSON of photos
    ///
    /// - Parameter result: JSON received from request photos
    /// - Returns: array of Photo
    private func parseJsonOfPhotos(result: Any?, for albumID: String?) -> [Photo] {
        var photos: [Photo] = []
        
        let json = JSON(result!)
        let data = JSON(json)
        let images = JSON(data["data"])
        // Get paging information
        let paging = JSON(data["paging"])
        let pagingAfter = JSON(JSON(paging["cursors"]))["after"].rawString()
        
        // Store the album next reference
        if let aID = albumID {
            photoPagingAlbumAfter.merge([aID: pagingAfter!]) { (_, string2) -> String in
                return string2
            }
        }
        
        for image in images {
            var idPhoto: String!
            if let idPhotoString = image.1["id"].rawString() {
                idPhoto = idPhotoString
            }

            var name: String? = image.1["name"].rawString()
            if name == "null" {
                name = nil
            }
            
            var source: URL!
            if let sourceString = image.1["source"].rawString() {
                source = URL(string: sourceString)
            }
            
            var width: Int!
            if let widthString = image.1["width"].rawString() {
                width = Int(widthString)
            }
            
            var height: Int!
            if let heightString = image.1["height"].rawString() {
                height = Int(heightString)
            }
            
            var date: Date?
            if let publishTime = image.1["created_time"].rawString() {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
                date = dateFormat.date(from: publishTime)
            }
            
            photos.append(Photo(idPhoto: idPhoto, name: name, source: source,
                                width: width, height: height, date: date))
        }
        return photos
    }
    
    /// Request for user albums
    ///
    /// - Returns: array of Album
    /// - Throws: error
    func getUserAlbums() throws -> [Album] {
        
        let path = "me/albums"
        var requestError: Error?
        var albums: [Album] = []
        let request = FBSDKGraphRequest(graphPath: path, parameters: ["fields" as NSObject: "" as AnyObject])
        
        // Start semaphore
        let semaphore = DispatchSemaphore(value: 0)
        _ = request?.start(completionHandler: { (_, result, error) in
            if error != nil {
                requestError = error
                return
            }
            // Parse information from JSON
            let data = JSON(result!)["data"]
            for item in data {
                let album = item.1
                var date: Date?
                if let publishTime = album["created_time"].rawString() {
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
                    date = dateFormat.date(from: publishTime)
                }
                albums.append(Album(idAlbum: album["id"].rawString()!,
                                    name: album["name"].rawString()!,
                                    date: date!))
            }
            semaphore.signal()
        })
        
        // Stop on semaphore
        semaphore.wait()
        
        // Check if an error occurred
        if let error = requestError {
            throw error
        }

        return albums
    }
    
    
    /// Get photos of album ID
    ///
    /// - Parameter from albumID: identifier for album
    /// - Returns: array of Photo
    /// - Throws: error
    func getAlbumPictures(from albumID: String, options: PhotoRequestOptions) throws -> [Photo] {
        let path = "\(albumID)/photos"
        let parameters: [String] = ["image", "name", "source", "width", "height", "created_time"]
        var photos: [Photo] = []
        
        do {
            try photos =
                executePhotosRequest(graphPath: path,
                                     parameters: parameters,
                                     options: options,
                                     albumID: albumID)
        } catch {
            throw error
        }
        return photos
    }
    
    /// Create a Facbook Request Parameter field
    /// from a String array
    ///
    /// - Parameter array: an array with the request fields
    /// - Returns: a single String with all the fields separated by comma
    private func createRequestParameters(from array: [String]) -> String {
        var result: String = ""
        result.append(array[0])
        
        // Add parameters to request string
        if array.count > 1 {
            for counter in 1..<array.count {
                result.append(", \(array[counter])")
            }
        }

        return result
    }
    
    /// Update the graphRequest path depending on the PhotoRequestOption
    /// option == .nextImages -> get the next pack of photos from the previous one
    /// option == .previousImages -> get the previous pack of photos from the previous one
    /// option == .fromBeginnig -> restar all photo collection
    ///
    /// - Parameters:
    ///   - path: the path to be updated
    ///   - option: the PhotoRequestOption
    /// - Returns: the new graphPath with the option
    private func updateRequestPath(path: String,
                                   for option: PhotoRequestOptions,
                                   with albumID: String?) -> String {
        var newPath: String = path
        var after: String!
        
        guard option == .nextImages else {
            return path
        }
        
        if let aID = albumID {
            if photoPagingAlbumAfter[aID] != nil &&
                photoPagingAlbumAfter[aID] != "null" {
                after = photoPagingAlbumAfter[aID]!
                newPath.append("?after=\(after!)")
            }
        }

        return newPath
    }
}
