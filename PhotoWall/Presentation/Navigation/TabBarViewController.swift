//
//  TabBarViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var photoWall: PhotoWallViewController?
    var albums: AlbumsSplitViewController?
    var settings: SettingsSplitViewController?
    var themes: ThemesViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get view controllers reference
        for view in self.viewControllers! {
            if let photo = view as? PhotoWallViewController {
                self.photoWall = photo
            } else if let albums = view as? AlbumsSplitViewController {
                self.albums = albums
            } else if let themes = view as? ThemesViewController {
                self.themes = themes
            } else if let settings = view as? SettingsSplitViewController {
                self.settings = settings
            }
        }
        
        // Assign the photowall controller to the other tabs
        settings?.photoWallViewController = photoWall
        albums?.photoWallViewController = photoWall
        themes?.photoWallViewController = photoWall
    }
}
