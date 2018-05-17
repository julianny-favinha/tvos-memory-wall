//
//  AlbumsDetailViewController.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/15/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumsDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var photoWallViewController: PhotoWallViewController?
    var theme: PhotoWallTheme = DefaultTheme()
    var photos: [Photo] = []
}

extension AlbumsDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ImageCollectionViewCell!
        
        if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
            as? ImageCollectionViewCell {
            cell = photoCell
        }
        
        cell.theme = self.theme
        cell.imageView.kf.setImage(with: photos[indexPath.row].source)
        
        return cell
    }
}
