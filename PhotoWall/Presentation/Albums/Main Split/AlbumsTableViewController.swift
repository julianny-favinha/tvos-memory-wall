//
//  AlbumsTableViewController.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/15/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AlbumsTableViewController: UIViewController {
    // Controllers
    
    //var detailViewController: 
    weak var splitRootViewController: AlbumsSplitViewController?
    weak var detailViewController: AlbumsDetailViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    // Headers and rows
    var headers: [String] = ["Local"]
    var rows: [[String]] =
        [[CategoryPhotos.abstract.rawValue.capitalized,
          CategoryPhotos.city.rawValue.capitalized,
          CategoryPhotos.gaming.rawValue.capitalized,
          CategoryPhotos.nature.rawValue.capitalized]]
    
    // State Dictionaries
    var localImagesDict: [String: Bool] = [:] // Category: Bool
    var facebookDict: [String: Bool] = [:] // ID: Bool

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allows selecing multiple albums
        self.tableView.allowsMultipleSelection = true
        
        // load Dictionaries
        if let dict = UserDefaultsManager.getLocalImagesDict() {
            localImagesDict = dict
        }
        
        // Update photos to display
        self.detailViewController?.activity.startAnimating()
        PhotosServices.init().getPhotosForAllAlbuns(completion: { (_, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.detailViewController?.activity.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    /// Add Facebook albums info
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FBSDKAccessToken.current() != nil {
            if headers.count > 1 {
                headers.remove(at: 1)
            }
            self.headers.append("Facebook")
            let albunsNames = FacebookAlbumReference.albuns.map { (album) -> String in
                return album.name
            }
            self.rows.append(albunsNames)
            self.tableView.reloadData()
        }
        facebookDict = UserDefaultsManager.getFacebookAlbuns()
    }
}

extension AlbumsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Number displayed Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headers[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headers.count
    }
    
    /// Create table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = self.rows[indexPath.section][indexPath.row]
        
        // Load the checkmarks for Local Images
        if indexPath.section == 0 {
            // Local Images
            if localImagesDict[rows[indexPath.section][indexPath.row]] == true {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
        
        // Load the chekcmarks for Facebook albuns
        if indexPath.section == 1 {
            // Facebook Albuns
            let key = FacebookAlbumReference.albuns[indexPath.row].idAlbum
            if facebookDict[key]! == true {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext,
                   with coordinator: UIFocusAnimationCoordinator) {
        if let indexPath = context.nextFocusedIndexPath {
            if indexPath.section == 1 {
                // Facebook Cells
                detailViewController?.photos = FacebookAlbumReference.albuns[indexPath.row].photos!
                detailViewController?.collectionView.reloadData()
            }
        }
    }
    
    /// Change Detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) {
            checkCell(cell: cell, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) {
            checkCell(cell: cell, indexPath: indexPath)
        }
    }
    
    private func checkCell(cell: UITableViewCell, indexPath: IndexPath) {
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        // Update user info for local images
        if indexPath.section == 0 {
            // Local Images
            if cell.accessoryType == .checkmark {
                localImagesDict[rows[0][indexPath.row]] = true
            } else {
                localImagesDict[rows[0][indexPath.row]] = false
            }
            UserDefaultsManager.setSelectedLocalImagesDict(to: localImagesDict)
        }
        
        // Update user info for Facebook albums
        else if indexPath.section == 1 {
            if cell.accessoryType == .checkmark {
                facebookDict[FacebookAlbumReference.albuns[indexPath.row].idAlbum] = true
            } else {
                facebookDict[FacebookAlbumReference.albuns[indexPath.row].idAlbum] = false
            }
            UserDefaultsManager.saveFacebookAlbuns(albuns: facebookDict)
        }
        splitRootViewController?.photoWallViewController?.reloadCollectionViewSource()
    }
}
