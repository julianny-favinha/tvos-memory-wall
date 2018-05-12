//
//  PhotoRequestOptions.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

/// Create Options for the Photo Requests
/// for every source
///
/// - fromBegining: restart the Photo Request
/// - nextImages: get new images - new page on paging
/// - previousImages: get the last images
enum PhotoRequestOptions {
    case fromBegining
    case nextImages
    case previousImages
}
