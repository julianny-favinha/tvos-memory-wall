//
//  ThemeCollectionViewCell.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: ImageCollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}
