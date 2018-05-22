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
    var selectedIndexPath: IndexPath?
    var selectedImage: UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUpImageSegue",
            let row = selectedIndexPath?.row,
            let image = selectedImage,
            let viewController = segue.destination as? PopUpViewController {
            viewController.photo = self.photos[row]
            viewController.image = image
        }
    }
}

extension AlbumsDetailViewController: UICollectionViewDataSource {
    /// get number of cells to be displayed
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    /// Create cells
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // change placeholder
        if self.photos[indexPath.row].height > self.photos[indexPath.row].width {
            theme.placeholder = #imageLiteral(resourceName: "placeholder2")
        } else {
            theme.placeholder = #imageLiteral(resourceName: "placeholder1")
        }
        
        var cell: ImageCollectionViewCell!
        
        if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
            as? ImageCollectionViewCell {
            cell = photoCell
        }
        
        cell.theme = self.theme
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: photos[indexPath.row].source,
                                   placeholder: theme.placeholder)
        return cell
    }
}

extension AlbumsDetailViewController: UICollectionViewDelegate {
    /// Selected a Cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            self.selectedImage = cell.imageView.image!
        }
        self.performSegue(withIdentifier: "PopUpImageSegue", sender: self)
    }
    
}
