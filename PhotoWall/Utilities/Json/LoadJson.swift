//
//  LoadJson.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/17/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoadJson {
    static let shared = LoadJson()
    var json: JSON?
    
    init() {
        json = loadJsonFromLocalFile(filename: "Photos")
    }
    
    /// Load json from a local file
    ///
    /// - Parameter filename: the name of the file to be loaded
    /// - Returns: return an JSON with the json loaded
    func loadJsonFromLocalFile(filename: String) -> JSON {
        var data: Data!
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path))
            } catch {
                print(error)
            }
        } else {
            print("ERROR: Word file not found: \(filename)")
        }
        return JSON(data)
    }
}
