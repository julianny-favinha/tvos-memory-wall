//
//  PublicProfileServices.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/10/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

class PublicProfileServices {
    let facebookMechanism: FacebookMechanism = FacebookMechanism()
    
    /// Get the profile information of the current User
    /// Async
    /// any UI updates depending on this request must be called
    /// on the completion Handler
    ///
    /// - Parameter completion: Completion Handler - runs async
    func getPublicProfile(completion: ((User, Error?) -> Void)?) {
        
        // Run async and call the completion handler at the end
        // if any UI update is needed - it must be called on the completion handler
        DispatchQueue.global().async {
            let graphPath = "me"
            let parameters: [String] = ["name", "first_name", "last_name", "email", "id", "picture"]
            var requestError: Error?
            var user: User!
            
            // Make facebook Mechanism Request
            // the mechanisms should return a [String: Any] dict
            // unles an error occured
            do {
                user = try self.facebookMechanism.executeRequest(graphPath: graphPath, parameters: parameters)
            } catch {
                requestError = error
            }
            
            // Execute completion
            if let completion = completion {
                completion(user, requestError)
            }
        }
    }
}
