//
//  BlackAndWhiteGridTheme.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 20/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

class BlackAndWhiteGridTheme: PhotoWallTheme {
    var placeholder: UIImage = #imageLiteral(resourceName: "placeholder1")
    var backgroundColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    var collectionViewLayout: CustomLayout = LinedGridLayout(numberOfLines: 2)
    var processor: ImageProcessor = BlackWhiteProcessor()
    var backgroundView: UIView?
    
    func transitionToSelectedState(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 20
            cell.layer.shadowColor = UIColor.black.cgColor
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
