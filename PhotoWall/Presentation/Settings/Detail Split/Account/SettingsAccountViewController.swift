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
    @IBOutlet weak var facebookFocusableView: FocusableView!
    @IBOutlet weak var loggedFacebookIcon: UIImageView!
    
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
    
    // Add gesture to buttons
    func makeButtons() {
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
        self.facebookPicture.kf.indicatorType = .activity
        
        if FBSDKAccessToken.current() != nil {
            self.loggedFacebookIcon.isHidden = false
            // get public profile
            publicProfileServices.getPublicProfile { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Final result")
                    print(result)
                    self.user = result as User
                    // Update information
                    DispatchQueue.main.async {
                        self.facebookLabel.text = self.user?.firstName
                    }
                }
            }
            
            // get profile picture
            let url: String = "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="
            self.facebookPicture.kf.setImage(with: URL(string: url+FBSDKAccessToken.current().tokenString))
        } else {
            self.loggedFacebookIcon.isHidden = true
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
    
    // Login Finished - tell the photoWall and albums
    func deviceLoginViewControllerDidFinish(_ viewController: FBSDKDeviceLoginViewController) {
        print("Log In")
        
        // remove checked options on local images dict
        var dict = UserDefaultsManager.getLocalImagesDict()
        for (key, _) in dict! {
            dict![key] = false
        }
        UserDefaultsManager.setSelectedLocalImagesDict(to: dict!)
        
        photoWallViewController?.collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        photoWallViewController?.scrollAmount = 0
        photoWallViewController?.reloadCollectionViewSource(option: .fromBegining)
        albumsTableViewController?.checkFacebookInformation(sender: self)
        updateFacebookInfo()
    }
    
    // Show alert of failed log in
    func deviceLoginViewControllerDidFail(_ viewController: FBSDKDeviceLoginViewController, error: Error) {
        print("Fail \(error)")
        // Present an alert with the Fail
        let alert = UIAlertController(title: "Log in Failed",
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
                                      message: "Are you sure you want to log out from Facebook?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            // Loggin Out
            FBSDKAccessToken.setCurrent(nil)
            self.updateFacebookInfo()
            
            UserDefaultsManager.saveFacebookAlbuns(albums: [:])
            
            let dict = [CategoryPhotos.abstract.rawValue: true,
                        CategoryPhotos.city.rawValue: false,
                        CategoryPhotos.gaming.rawValue: false,
                        CategoryPhotos.nature.rawValue: false]
            UserDefaultsManager.setSelectedLocalImagesDict(to: dict)
            
            FacebookAlbumReference.albums = []
            self.photoWallViewController?.reloadCollectionViewSource(option: .fromBegining)
            self.albumsTableViewController?.updateHeaders()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
