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
    var settings: SettingsSplitViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for view in self.viewControllers! {
            if let photo = view as? PhotoWallViewController {
                self.photoWall = photo
            } else if let settings = view as? SettingsSplitViewController {
                self.settings = settings
            }
        }
        
        // Assign the photowall controller to settings delegate
        settings?.photoWallViewController = photoWall
    }
    
}
