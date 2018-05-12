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
    var photoWallViewController: PhotoWallViewController?
    var photoWallThemes: PhotoWallThemes = PhotoWallThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFacebookButton()
    }
    
    func setTheme() {
        // Set the Current Theme
        if let parent = photoWallViewController {
            self.view.backgroundColor = parent.theme.backgroundColor
        }
    }

    /// Add Facebook Login Button to screen
    func addFacebookButton() {
        let fbButton = FBSDKDeviceLoginButton()
        fbButton.readPermissions = ["user_photos"]
        fbButton.center = self.view.center
        fbButton.delegate = self
        self.view.addSubview(fbButton)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoWallThemes.themes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select the wall theme"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = photoWallThemes.themes[indexPath.row].rawValue
        return cell!
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parent = photoWallViewController {
            
            // Tell the photoWall to update the Theme
            parent.theme = photoWallThemes.themeDict[photoWallThemes.themes[indexPath.row]]!
            parent.restartTheme()
            
            // Present an alert with the Change
            let alert = UIAlertController(title: "\(photoWallThemes.themes[indexPath.row].rawValue)",
                message: "The photo wall theme was changed to \(photoWallThemes.themes[indexPath.row].rawValue), go back to your photos to see it!",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            // Change theme on the settings
            UIView.animate(withDuration: 1.0) {
                self.setTheme()
            }
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
