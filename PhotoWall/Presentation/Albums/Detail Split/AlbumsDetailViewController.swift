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
    
    var photoWallViewController: PhotoWallViewController?
    var theme: PhotoWallTheme = DefaultTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AlbumsDetailViewController: UICollectionViewDelegate {
}

extension AlbumsDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ImageCollectionViewCell!
        
        if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
            as? ImageCollectionViewCell {
            cell = photoCell
        }
        
        cell.theme = self.theme
        
        // TODO
//        cell.imageView.kf.setImage(with: ImageModel.getNextPhotoURL(), placeholder: #imageLiteral(resourceName: "placeholder"))
        
        return cell
    }
}
