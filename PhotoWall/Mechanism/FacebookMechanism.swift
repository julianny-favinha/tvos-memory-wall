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
    
    /// Make a Facebook Graph API Request
    /// Sync
    ///
    /// - Parameters:
    ///   - graphPath: the graphPath description (me: profile, me/photos...)
    ///   - parameters: the request fields
    /// - Returns: A [String:Any] dict with the requested fields
    ///            if the field didn't come, the value will be NULL
    func executeRequest(graphPath: String, parameters: [String]) throws -> [String: Any] {
        
        // Create returning variable
        var dict: [String: Any] = [:]
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
                // Convert result into JSON - SwiftyJson library
                let json = JSON(result!)
                // Update dict
                for field in parameters {
                    dict[field] = json[field]
                }
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
        return dict
    }
    
    func executePhotosRequest(graphPath: String, parameters: [String]) throws -> [Photo] {
        var photos: [Photo] = []
        
        let convertedParameters: String = createRequestParameters(from: parameters)
        let requestParameters: [NSObject: AnyObject] = ["fields" as NSObject: convertedParameters as AnyObject]
        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: requestParameters)
        
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
                let json = JSON(result!)
                let data = JSON(json)
                let images = JSON(data["data"])
                
                for image in images {
                    var idPhoto: String!
                    if let idString = image.1["id"].rawString() {
                        idPhoto = idString
                    }
                    
                    let name: String? = image.1["name"].rawString()
                    
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
                    
                    photos.append(Photo(idPhoto: idPhoto, name: name, source: source, width: width, height: height))
                }
                
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
    
    /// Create a Facbook Request Parameter field
    /// from a String array
    ///
    /// - Parameter array: an array with the request fields
    /// - Returns: a single String with all the fields separated by comma
    private func createRequestParameters(from array: [String]) -> String {
        var result: String = ""
        result.append(array[0])
        if array.count > 1 {
            for counter in 1..<array.count {
                result.append(", \(array[counter])")
            }
        }
        return result
    }
}
