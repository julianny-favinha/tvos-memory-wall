//
//  PopUpViewController.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var image: UIImage?
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image
        if let photo = self.photo {
            let format = DateFormatter()
            format.dateFormat = "dd/MM/yyyy HH:mm"
            
            if let date = self.photo?.date {
                captionLabel.text = "\(photo.name!) \(format.string(from: date))"
            } else {
                captionLabel.text = "\(photo.name!)"
            }
        }
    }
}
