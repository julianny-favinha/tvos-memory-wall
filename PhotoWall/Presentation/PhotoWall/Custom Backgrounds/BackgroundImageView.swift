//
//  BackgroundImageView.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class BackgroundImageView: UIView {
    var image: UIImage!
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let imageView = UIImageView(frame: self.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.image = self.image
        self.addSubview(imageView)
    }
}
