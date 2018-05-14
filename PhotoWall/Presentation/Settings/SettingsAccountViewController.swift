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
    @IBOutlet weak var facebookPicture: UIImageView!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet var roundViews: [UIView]!
    @IBOutlet weak var facebookFocusableView: FocusableView!
    
    weak var photoWallViewController: PhotoWallViewController?
    var publicProfileServices: PublicProfileServices = PublicProfileServices()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFacebookButton()
        if user != nil {
            // Logged and user loaded
            self.facebookPicture.kf.setImage(with: self.user?.profilePicture)
            self.facebookLabel.text = self.user?.firstName
        } else {
            updateFacebookInfo()
        }
        makeButtons()
    }
    
    // Making views rounded
    func makeButtons() {
        for view in roundViews {
            view.layer.cornerRadius = view.frame.size.width/2
            view.clipsToBounds = true
        }
        facebookFocusableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookButtonTapped(_:))))
    }
    
    @objc func facebookButtonTapped(_ tapGesture: UITapGestureRecognizer) {
        print("TAPTAPTAP")
        self.facebookFocusableView.bounce()
    }
    
    /// Add Facebook Login Button to screen
    func addFacebookButton() {
        let fbButton = FBSDKDeviceLoginButton()
        fbButton.readPermissions = ["user_photos"]
        fbButton.center = fbGuideView.center
        fbButton.delegate = self
        self.view.addSubview(fbButton)
    }
    
    // Update facebook info - get profile picture and name
    func updateFacebookInfo() {
        if FBSDKAccessToken.current() != nil {
            publicProfileServices.getPublicProfile { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Final result")
                    print(result)
                    self.user = result as User
                    // Update information
                    DispatchQueue.main.async {
                        self.facebookPicture.kf.indicatorType = .activity
                        self.facebookPicture.kf.setImage(with: self.user?.profilePicture)
                        self.facebookLabel.text = self.user?.firstName
                    }
                }
            }
        } else {
            self.facebookPicture.image = #imageLiteral(resourceName: "facebook-icon")
            self.facebookLabel.text = "Log In"
        }
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
        updateFacebookInfo()
    }
    
    // User Logged out - remove photos from current photowall
    func deviceLoginButtonDidLogOut(_ button: FBSDKDeviceLoginButton) {
        print("Log Out")
        photoWallViewController?.collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        photoWallViewController?.scrollAmount = 0
        photoWallViewController?.reloadCollectionViewSource()
        updateFacebookInfo()
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
