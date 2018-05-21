//
//  SettingsSplitViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class SettingsSplitViewController: UISplitViewController {
    // Controllers
    var photoWallViewController: PhotoWallViewController?
    var masterViewController: SettingsTableViewController?
    var accountViewController: SettingsAccountViewController?
    var privacyPolicyViewController: SettingsPrivacyPolicyViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading ViewControllers
        if let master = self.viewControllers.first as? SettingsTableViewController {
            self.masterViewController = master
        }
        
        if let account = self.viewControllers.last  as? SettingsAccountViewController {
            self.accountViewController = account
        }
        
        if let privacyPolicy = UIStoryboard(
            name: "SettingsPrivacyPolicy",
            bundle: nil).instantiateViewController(withIdentifier: "privacyPolicyStoryboard")
                        as? SettingsPrivacyPolicyViewController {
            privacyPolicyViewController = privacyPolicy
        }
        
        // Assign delegates and references
        self.masterViewController?.splitRootViewController = self
        self.accountViewController?.photoWallViewController = self.photoWallViewController
        
        // First detail view
        self.showDetailViewController(accountViewController!, sender: self)
    }
}
