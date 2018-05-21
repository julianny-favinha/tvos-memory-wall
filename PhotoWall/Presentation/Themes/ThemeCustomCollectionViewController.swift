//
//  ThemeCustomCollectionViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class ThemeCustomCollectionViewController: UIViewController {
    weak var mainViewController: ThemesViewController?
}

extension ThemeCustomCollectionViewController:
UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Last cell is the adition Cell
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aditionCell", for: indexPath)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "themeCell", for: indexPath) as? ThemeCollectionViewCell
            else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}
