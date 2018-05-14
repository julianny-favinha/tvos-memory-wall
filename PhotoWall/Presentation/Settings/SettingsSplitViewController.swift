//
//  SettingsSplitViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class SettingsSplitViewController: UISplitViewController {
    
    var photoWallViewController: PhotoWallViewController?
    var masterViewController: SettingsTableViewController?
    var themeViewController: SettingsViewController?
    var accountViewController: SettingsAccountViewController?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let master = self.viewControllers.first as? SettingsTableViewController {
            self.masterViewController = master
        }
        if let theme = self.viewControllers.last  as? SettingsViewController {
            self.themeViewController = theme
        }
        if let account = UIStoryboard(
            name: "Settings",
            bundle: nil).instantiateViewController(withIdentifier: "account") as? SettingsAccountViewController {
            accountViewController = account
        }
        
        // Assign delegates and references
        self.masterViewController?.splitRootViewController = self
        self.themeViewController?.photoWallViewController = self.photoWallViewController
        self.accountViewController?.photoWallViewController = self.photoWallViewController
        themeViewController?.setTheme()
    }
}
