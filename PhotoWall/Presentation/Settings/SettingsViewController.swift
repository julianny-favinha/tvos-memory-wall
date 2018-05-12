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

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var themeImageView: UIImageView!
    // Remove thin when unecessary
    @IBOutlet weak var fbGuideView: UIView!
    var photoWallViewController: PhotoWallViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFacebookButton()
        setTheme()
    }
    
    func setTheme() {
        // Set the Current Theme
        if let parent = photoWallViewController {
            self.view.backgroundColor = parent.theme.backgroundColor
        }
    }
    
    func changeThemeImage(to theme: Theme) {
        UIView.transition(with: themeImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.themeImageView.image = PhotoWallThemes.themeImage[theme]
        }, completion: nil)
    }

    /// Add Facebook Login Button to screen
    func addFacebookButton() {
        let fbButton = FBSDKDeviceLoginButton()
        fbButton.readPermissions = ["user_photos"]
        fbButton.center = fbGuideView.center
        fbButton.delegate = self
        self.view.addSubview(fbButton)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoWallThemes.themes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select the wall theme"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = PhotoWallThemes.themeName[PhotoWallThemes.themes[indexPath.row]]
        return cell!
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView,
                   didUpdateFocusIn context: UITableViewFocusUpdateContext,
                   with coordinator: UIFocusAnimationCoordinator) {
        if let indexPath = context.nextFocusedIndexPath {
            let theme = PhotoWallThemes.themes[indexPath.row]
            changeThemeImage(to: theme)
        }
    }
}

extension SettingsViewController: FBSDKDeviceLoginButtonDelegate {
    func deviceLoginButtonDidCancel(_ button: FBSDKDeviceLoginButton) {
        print("Cancel")
    }

    func deviceLoginButtonDidLog(in button: FBSDKDeviceLoginButton) {
        print("Log In")
    }

    func deviceLoginButtonDidLogOut(_ button: FBSDKDeviceLoginButton) {
        print("Log Out")
    }

    func deviceLoginButtonDidFail(_ button: FBSDKDeviceLoginButton, error: Error) {
        print("Fail \(error)")
    }
}
