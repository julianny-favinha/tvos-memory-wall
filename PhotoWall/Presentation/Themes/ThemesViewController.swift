//
//  SettingsViewController.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKTVOSKit
import AudioToolbox

class ThemesViewController: UIViewController {

    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var customThemesCollectionView: UICollectionView!
    
    weak var photoWallViewController: PhotoWallViewController?
    var customCollectionViewController = ThemeCustomCollectionViewController()
    var currentTheme: PhotoWallTheme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set collection View Sources
        customCollectionViewController.setup()
        customThemesCollectionView.dataSource = customCollectionViewController
        customThemesCollectionView.delegate = self
        setTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customCollectionViewController.setup()
        customThemesCollectionView.reloadData()
    }
    
    // Set the photoWall Theme on parent view
    func setTheme() {
        // Set the Current Theme
        if let parent = photoWallViewController {
            self.view.backgroundColor = parent.theme.backgroundColor
        }
    }
    
    // Change the settings theme image
    func changeThemeImage(to theme: Theme) {
        UIView.transition(with: themeImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.themeImageView.image = PhotoWallThemes.themeImage[theme]
        }, completion: nil)
    }
}

extension ThemesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // Collection View Controller
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoWallThemes.themes.count
    }
    
    // Create cells
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "themeCell",
                                                            for: indexPath) as? ThemeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = PhotoWallThemes.themeName[PhotoWallThemes.themes[indexPath.row]]
        cell.imageView.image = PhotoWallThemes.themeImage[PhotoWallThemes.themes[indexPath.row]]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == customThemesCollectionView {
            if indexPath.row == customThemesCollectionView.numberOfItems(inSection: 0) - 1 {
                // Adition Cell
                self.performSegue(withIdentifier: "customizeThemeSegue", sender: self)
                return
            } else {
                // Custom Themes
                guard let cell = collectionView.cellForItem(at: indexPath) as? CustomizationCollectionViewCell else {
                    return
                }
                let userTheme = customCollectionViewController.themeDict![cell.label.text!]
                
                if let parent = photoWallViewController, let selectedTheme =  userTheme?.createCustomTheme() {
                    parent.theme = selectedTheme
                    parent.restartTheme()
                    
                    // Present an alert with the Change
                    let alert = UIAlertController(title: "\(cell.label.text!)",
                        message: "The photo wall theme was changed to " +
                            "a user created theme" +
                        " go back to your photos to see it!",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
        
        if let parent = photoWallViewController {
            // Tell the photoWall to update the Theme
            let selectedTheme = PhotoWallThemes.themes[indexPath.row]
            parent.theme = PhotoWallThemes.themeDict[selectedTheme]!
            parent.restartTheme()

            // Save preferred theme to UserDefaults
            UserDefaultsManager.setPreferredTheme(to: selectedTheme)

            // Present an alert with the Change
            let alert = UIAlertController(title: "\(PhotoWallThemes.themeName[selectedTheme]!)",
                message: "The photo wall theme was changed to " +
                    "\(PhotoWallThemes.themeName[selectedTheme]!)," +
                    " go back to your photos to see it!",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            // Change theme on the settings
            UIView.animate(withDuration: 1.0) {
                self.setTheme()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        // change self theme
        if let indexPath = context.nextFocusedIndexPath {
            currentTheme = PhotoWallThemes.themeDict[PhotoWallThemes.themes[indexPath.row]]
        } else {
            currentTheme = photoWallViewController?.theme
        }
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = self.currentTheme?.backgroundColor
        }
        
        // Selected cell
        if let indexPath = context.nextFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                currentTheme?.transitionToSelectedState(cell: cell)
            }
        }
        // Unselected cell
        if let indexPath = context.previouslyFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                currentTheme?.transitionToUnselectedState(cell: cell)
            }
        }
    }
    
    /// Allows every cell to be focusable
    /// if false: the current cell will be selected using the remote
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
