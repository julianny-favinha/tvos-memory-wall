//
//  PlaceholderImageView.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class PlaceholderImageView: UIImageView {
    /// Makes a the collection view cell start and stop the activity indicator depending on the current image
    override var image: UIImage? {
        didSet {
            if image == #imageLiteral(resourceName: "placeholder") {
                delegate?.activity.startAnimating()
            } else {
                delegate?.activity.stopAnimating()
            }
        }
    }
    weak var delegate: ImageCollectionViewCell?
}
