//
//  AlbumsSplitViewController.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/15/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class AlbumsSplitViewController: UISplitViewController {
    // Controllers
    var photoWallViewController: PhotoWallViewController?
    var masterViewController: AlbumsTableViewController?
    var facebookViewController: AlbumsFacebookViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading ViewControllers
        if let master = self.viewControllers.first as? AlbumsTableViewController {
            self.masterViewController = master
        }
        if let facebook = self.viewControllers.last as? AlbumsFacebookViewController {
            self.facebookViewController = facebook
        }
        
        // Assign delegates and references
        self.masterViewController?.splitRootViewController = self
        self.facebookViewController?.photoWallViewController = self.photoWallViewController
        
        // First detail view
        self.showDetailViewController(facebookViewController!, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
