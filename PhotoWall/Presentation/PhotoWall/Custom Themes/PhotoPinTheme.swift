//
//  PhotoPinTheme.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoPinTheme: PhotoWallTheme {
    var placeholder: UIImage = #imageLiteral(resourceName: "placeholder1")
    var backgroundColor: UIColor = #colorLiteral(red: 0.5079426765, green: 0.8540073037, blue: 0.9591421485, alpha: 0.4952108305)
    var collectionViewLayout: UICollectionViewLayout = DefaultLayout()
    var processor: ImageProcessor = DefaultImageProcessor()
    var backgroundView: UIView?

    func createCell(for indexPath: IndexPath,
                    from collectionView: UICollectionView, with photo: Photo) -> ImageCollectionViewCell {
        
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "polaroidCell", for: indexPath) as?
            PolaroidCollectionViewCell else {
                return ImageCollectionViewCell()
        }
        cell.label.text = "\(photo.name ?? "")"
        cell.photoBorderView.transform =
            CGAffineTransform.init(rotationAngle: CGFloat(0.1 - Double(arc4random_uniform(20))/100))
        return cell
    }
    
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
