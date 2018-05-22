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
        
        // Add edit gesture on collectionView
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        customThemesCollectionView.addGestureRecognizer(longPress)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customCollectionViewController.setup()
        customThemesCollectionView.reloadData()
    }
    
    // Get long press on the collectoinView
    /// Handle the long press - Edit the cell
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        let point = gesture.location(in: self.customThemesCollectionView)
        //Adition cell
        if self.customThemesCollectionView.indexPathForItem(at: point)?.row ==
            customThemesCollectionView.numberOfItems(inSection: 0) - 1 {
            return
        }
        
        if gesture.state == .began {
            if let indexPath = self.customThemesCollectionView.indexPathForItem(at: point) {
                // get the cell at indexPath (the one you long pressed)
                guard let cell = self.customThemesCollectionView.cellForItem(at: indexPath)
                    as? ThemeCollectionViewCell else {
                        return
                }
                cell.selectCell()
            } else {
                print("couldn't find index path")
            }
        }
        
        if gesture.state != .ended {
            return
        }
        
        if let indexPath = self.customThemesCollectionView.indexPathForItem(at: point) {
            // get the cell at indexPath (the one you long pressed)
            guard let cell = self.customThemesCollectionView.cellForItem(at: indexPath)
                as? ThemeCollectionViewCell else {
                return
            }
            let alert = UIAlertController(title: "\(cell.titleLabel.text!)",
                message: "Do you want to edit this theme?",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
                self.performSegue(withIdentifier: "customizeThemeSegue", sender: cell.titleLabel.text!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                UserDefaultsManager.removeUserTheme(with: cell.titleLabel.text!)
                self.customThemesCollectionView.deleteItems(at: [indexPath])
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            print("couldn't find index path")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customizeThemeSegue" && sender is String {
            if let view = segue.destination as? CustomizeThemeViewController,
               let name = sender as? String {
                view.name = name
            }
        }
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
                guard let cell = collectionView.cellForItem(at: indexPath) as? ThemeCollectionViewCell else {
                    return
                }
                let userTheme = customCollectionViewController.themeDict![cell.titleLabel.text!]
                
                if let parent = photoWallViewController, let selectedTheme =  userTheme?.createCustomTheme() {
                    parent.theme = selectedTheme
                    parent.restartTheme()
                    
                    // Present an alert with the Change
                    let alert = UIAlertController(title: "\(cell.titleLabel.text!)",
                        message: "The photo wall theme was changed to " +
                            "a user created theme" +
                        " go back to your photos to see it!",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
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

        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        // change self theme
        currentTheme = photoWallViewController?.theme
        
        // Selected cell
        if let indexPath = context.nextFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ThemeCollectionViewCell {
                cell.transitionToSelectedState()
            }
        }
        // Unselected cell
        if let indexPath = context.previouslyFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ThemeCollectionViewCell {
                cell.transitionToUnselectedState()
            }
        }
    }
    
    /// Allows every cell to be focusable
    /// if false: the current cell will be selected using the remote
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
