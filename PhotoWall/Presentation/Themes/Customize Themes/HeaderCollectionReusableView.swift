//
//  HeaderCollectionReusableView.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var label: UILabel!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10
    }
}
