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
    var themeDict: [String: UserTheme]?
    var themeArray: [String] = []
    
    // Load Custom Themes from user Defaults
    func setup() {
        themeDict = UserDefaultsManager.getDecodedUserThemes()
        if let dict = themeDict {
            themeArray = dict.map({ (key, _) -> String in
                return key
            })
        }
    }
}

extension ThemeCustomCollectionViewController:
UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dict = themeDict {
            return 1 + dict.count
        }
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
        cell.titleLabel.text = themeArray[indexPath.row]
        return cell
    }
    
}
