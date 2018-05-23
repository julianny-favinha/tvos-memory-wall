//
//  PartyTheme.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 20/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

class PartyTheme: PhotoWallTheme {
    var placeholder: UIImage = #imageLiteral(resourceName: "placeholder1")
    var backgroundColor: UIColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 0.1993792808)
    var collectionViewLayout: CustomLayout = LinedGridLayout(numberOfLines: 3)
    var processor: ImageProcessor = BlendImageProcessor(blendMode: .darken, alpha: 1.0, backgroundColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0.8726128472, alpha: 1))
    
    var backgroundView: UIView? = ConfettiView()
    
    func transitionToSelectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 20
            cell.layer.shadowColor = UIColor.magenta.cgColor
        }
    }
    func transitionToUnselectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 5
            cell.layer.shadowColor = UIColor.black.cgColor
        }
    }
}
