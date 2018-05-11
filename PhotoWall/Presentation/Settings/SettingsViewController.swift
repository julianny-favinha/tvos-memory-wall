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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFacebookButton()
    }

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
        return ThemeReference.themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = ThemeReference.themes[indexPath.row].rawValue
        return cell!
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parent = photoWallViewController {
            parent.theme = ThemeReference.themeDict[ThemeReference.themes[indexPath.row]]!
            parent.restartTheme()
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
