//
//  SettingsAccountViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKTVOSKit

class SettingsAccountViewController: UIViewController {
    @IBOutlet weak var fbGuideView: UIView!
    
    weak var photoWallViewController: PhotoWallViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFacebookButton()
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

extension SettingsAccountViewController: FBSDKDeviceLoginButtonDelegate {
    // user cancelled log in - do nothing basically
    func deviceLoginButtonDidCancel(_ button: FBSDKDeviceLoginButton) {
        print("Cancel")
    }
    
    // Login Finished - tell the photoWall
    func deviceLoginButtonDidLog(in button: FBSDKDeviceLoginButton) {
        print("Log In")
        photoWallViewController?.collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        photoWallViewController?.scrollAmount = 0
        photoWallViewController?.reloadCollectionViewSource()
    }
    
    // User Logged out - remove photos from current photowall
    func deviceLoginButtonDidLogOut(_ button: FBSDKDeviceLoginButton) {
        print("Log Out")
        photoWallViewController?.collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        photoWallViewController?.scrollAmount = 0
        photoWallViewController?.reloadCollectionViewSource()
    }
    
    // Show alert of failed log in
    func deviceLoginButtonDidFail(_ button: FBSDKDeviceLoginButton, error: Error) {
        print("Fail \(error)")
        // Present an alert with the Fail
        let alert = UIAlertController(title: "Login Failed",
                                      message: "The log in could not be finished, " +
            "check your internet connection of facebook account",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
