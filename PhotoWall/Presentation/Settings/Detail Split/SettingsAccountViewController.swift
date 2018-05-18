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
    @IBOutlet weak var facebookBorder: UIImageView!
    
    weak var photoWallViewController: PhotoWallViewController?
    weak var albumsTableViewController: AlbumsTableViewController?
    
    var publicProfileServices: PublicProfileServices = PublicProfileServices()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            // Logged and user loaded
            self.facebookPicture.kf.setImage(with: self.user?.profilePicture)
            self.facebookLabel.text = self.user?.name
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
        facebookFocusableView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(facebookButtonTapped(_:))))
    }
    
    /// Facebook Button tapped
    @objc func facebookButtonTapped(_ tapGesture: UITapGestureRecognizer) {
        self.facebookFocusableView.bounce()
        facebookLoginButtonClicked()
    }
    
    /// Once the button is clicked, show the login dialog
    @objc func facebookLoginButtonClicked() {
        if FBSDKAccessToken.current() == nil {
            // Log in
            // Load the Facebook login viewController
            let fbView = FBSDKDeviceLoginViewController()
            fbView.delegate = self
            self.present(fbView, animated: true, completion: nil)
        } else {
            facebookLogOut()
        }
        
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
                        self.facebookBorder.image = #imageLiteral(resourceName: "facebookLoggedBorder")
                        self.facebookPicture.kf.indicatorType = .activity
                        self.facebookPicture.kf.setImage(with: self.user?.profilePicture)
                        self.facebookLabel.text = self.user?.firstName
                    }
                }
            }
        } else {
            facebookBorder.image = #imageLiteral(resourceName: "facebookOutBorder")
            self.facebookPicture.image = #imageLiteral(resourceName: "facebook-icon")
            self.facebookLabel.text = "Log In"
        }
    }

}

extension SettingsAccountViewController: FBSDKDeviceLoginViewControllerDelegate {
    // user cancelled log in - do nothing basically
    func deviceLoginViewControllerDidCancel(_ viewController: FBSDKDeviceLoginViewController) {
        print("Cancel")
    }
    
    // Login Finished - tell the photoWall
    func deviceLoginViewControllerDidFinish(_ viewController: FBSDKDeviceLoginViewController) {
        print("Log In")
        photoWallViewController?.collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        photoWallViewController?.scrollAmount = 0
        photoWallViewController?.reloadCollectionViewSource(option: .fromBegining)
        albumsTableViewController?.checkFacebookInformation()
        updateFacebookInfo()
    }
    
    // Show alert of failed log in
    func deviceLoginViewControllerDidFail(_ viewController: FBSDKDeviceLoginViewController, error: Error) {
        print("Fail \(error)")
        // Present an alert with the Fail
        let alert = UIAlertController(title: "Login Failed",
                                      message: "The log in could not be finished, " +
            "check your internet connection of facebook account",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Make log out
    func facebookLogOut() {
        print("Log out")
        let alert = UIAlertController(title: "Log out from Facebook",
                                      message: "Are you sure you want to log out of Facebook?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            // Loggin Out
            FBSDKAccessToken.setCurrent(nil)
            self.updateFacebookInfo()
            
            UserDefaultsManager.saveFacebookAlbuns(albums: [:])
            
            FacebookAlbumReference.albums = []
            self.photoWallViewController?.reloadCollectionViewSource(option: .fromBegining)
            self.albumsTableViewController?.updateHeaders()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
