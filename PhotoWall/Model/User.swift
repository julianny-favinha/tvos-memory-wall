//
//  User.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/14/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class User {
    var uid: String
    var name: String
    var firstName: String
    var lastName: String
    var email: String?
    var profilePicture: URL
    
    /// Create USer object
    init(uid: String, name: String, firstName: String, lastName: String, email: String?, profilePicture: URL) {
        self.uid = uid
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePicture = profilePicture
    }
}
