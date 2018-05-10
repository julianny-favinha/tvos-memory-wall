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
