//
//  GIFBackground.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class GIFBackground: UIView {
    var imageName: String = ""
    var ext: String = ""
    
    init(image: String, ext: String) {
        self.imageName = image
        self.ext = ext
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let imageView = UIImageView(frame: self.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.kf.setImage(with: Bundle.main.url(forResource: imageName, withExtension: ext))
        self.addSubview(imageView)
    }
}
