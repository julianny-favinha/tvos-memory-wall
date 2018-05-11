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

    func getPhotos(completion: (([String: [Any]], Error?) -> Void)?) {
        DispatchQueue.global().async {
            // TODO: get photos tagged
            let graphPath = "me/photos/?limit=30&type=uploaded"
            let parameters: [String] = ["source"]
            var requestError: Error?
            var urls: [String: [Any]] = [:]
            
            do {
                urls = try self.facebookMechanism.executePhotosRequest(graphPath: graphPath, parameters: parameters)
            } catch {
                requestError = error
            }
        
            if let completion = completion {
                completion(urls, requestError)
            }
        }
    }
}
