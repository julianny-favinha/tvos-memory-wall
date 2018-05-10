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
    
    func getPublicProfile() {
        let graphPath = "me"
        let parameters: [NSObject : AnyObject] = ["fields" as NSObject: "name" as AnyObject]
        
        facebookMechanism.executeRequest(graphPath: graphPath, parameters: parameters)
    }
}
