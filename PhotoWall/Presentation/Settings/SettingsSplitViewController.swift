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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let master = self.viewControllers.first as? SettingsTableViewController {
            self.masterViewController = master
        }
        if let account = self.viewControllers.last  as? SettingsAccountViewController {
            self.accountViewController = account
        }
        if let theme = UIStoryboard(
            name: "SettingsThemes",
            bundle: nil).instantiateViewController(withIdentifier: "SettingsThemes") as? SettingsViewController {
            themeViewController = theme
        }
        
        // Assign delegates and references
        self.masterViewController?.splitRootViewController = self
        self.themeViewController?.photoWallViewController = self.photoWallViewController
        self.accountViewController?.photoWallViewController = self.photoWallViewController
        themeViewController?.setTheme()
        
        // First detail view
        self.showDetailViewController(accountViewController!, sender: self)
    }
}
