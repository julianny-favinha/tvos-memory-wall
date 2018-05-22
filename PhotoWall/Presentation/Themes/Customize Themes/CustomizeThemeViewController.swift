//
//  CustomizeThemeViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

/* Controls 3 different collectionViews
 one for each customizable */

class CustomizeThemeViewController: UIViewController {
    
    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    @IBOutlet weak var previewView: UIView!
    
    // Default values
    var selectedLayout: Layouts = .singleLine
    var selectedPhotoCell: Cells = .simple
    var selectedBackground: Backgrounds = .light
    
    /// Save button pressed
    /// Save the new theme to the User Defaults
    /// Dismiss the screen
    @IBAction func saveButtonTouched(_ sender: Any) {
        let newTheme = UserTheme(name:
            "Custom Theme \(UserDefaultsManager.getUserThemes().count + 1)",
                                 photo: self.selectedPhotoCell.rawValue,
                                 layout: self.selectedLayout.rawValue,
                                 background: self.selectedBackground.rawValue,
                                 image: previewView.snapshot()!)
        UserDefaultsManager.addUserTheme(newTheme)
        
        let alert = UIAlertController(title:
            "Custom Theme \(UserDefaultsManager.getUserThemes().count)",
            message: "New theme created", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CustomizeThemeViewController:
UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Get the number of cells on each collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == backgroundCollectionView {
            return ThemeCustomization.backgrounds.count
        } else if collectionView == photoCollectionView {
            return ThemeCustomization.cells.count
        } else if collectionView == layoutCollectionView {
            return ThemeCustomization.layouts.count
        }
        return 0
    }
    
    /// Create Headers
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind:
            UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "customCell", for: indexPath) as? CustomizationCollectionViewCell else {
            return UICollectionViewCell()
        }
        let row = indexPath.row
        
        if collectionView == backgroundCollectionView {
            // Backgrounds
            let background = ThemeCustomization.backgrounds[row]
            cell.label.text = background.rawValue
            cell.imageView.image = ThemeCustomization.backgroundImage[background]
            if background == selectedBackground {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
        } else if collectionView == photoCollectionView {
            // Photo
            let photoCell = ThemeCustomization.cells[row]
            cell.label.text = photoCell.rawValue
            cell.imageView.image = ThemeCustomization.cellsImages[photoCell]
            if photoCell == selectedPhotoCell {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
        } else if collectionView == layoutCollectionView {
            // layout
            let layout = ThemeCustomization.layouts[row]
            cell.label.text = layout.rawValue
            cell.imageView.image = ThemeCustomization.layoutImages[layout]
            if layout == selectedLayout {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        if collectionView == backgroundCollectionView {
            self.selectedBackground = ThemeCustomization.backgrounds[row]
            backgroundCollectionView.reloadData()
        } else if collectionView == layoutCollectionView {
            self.selectedLayout = ThemeCustomization.layouts[row]
            layoutCollectionView.reloadData()
        } else if collectionView == photoCollectionView {
            self.selectedPhotoCell = ThemeCustomization.cells[row]
            photoCollectionView.reloadData()
        }
    }
}
