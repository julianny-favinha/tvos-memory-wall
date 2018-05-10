//
//  FacebookServices.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/10/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookMechanism {
    func executeRequest(graphPath: String, parameters: [NSObject : AnyObject]!) {
        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
        graphRequest?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(result)
            }
        })
    }
}
