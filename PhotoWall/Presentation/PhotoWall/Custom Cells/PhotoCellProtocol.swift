//
//  PhotoCellProtocol.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

// This father class will allow different cells to be created
// and used on the photo wall
class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func transitionToSelectedState(cell: UICollectionViewCell) {
        print("Must override")
    }
    func transitionToUnselectedState(cell: UICollectionViewCell) {
        print("Must override")
    }
}
