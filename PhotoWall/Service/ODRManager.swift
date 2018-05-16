//
//  ODRManager.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/15/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

class ODRManager {
    static let shared = ODRManager()
    var currentRequest: NSBundleResourceRequest?
    
    /// Requesting resources with tag
    ///
    /// - Parameters:
    ///   - tag: tag of the on-demand resource that will be retrieved
    ///   - onSuccess: success handler
    ///   - onFailure: failure handler
    func requestPhotosWith(tag: String, onSuccess: @escaping () -> Void, onFailure: @escaping (NSError) -> Void) {
        // perform request
        currentRequest = NSBundleResourceRequest(tags: [tag])
        
        // verify if was successful
        guard let request = currentRequest else { return }
        
        request.beginAccessingResources { (error: Error?) in
            if let error = error {
                onFailure(error as NSError)
                return
            }

            // the app can assume the resource is available for use
            onSuccess()
        }
    }
}
