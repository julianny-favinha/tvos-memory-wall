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
    
    var imageModel: ImageModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allows selecing multiple albums
        self.tableView.allowsMultipleSelection = true
        
        // load Dictionaries
        if let dict = UserDefaultsManager.getLocalImagesDict() {
            localImagesDict = dict
        }
        checkFacebookInformation(sender: self)
    }
    
    /// Update headers of table view
    func updateHeaders() {
        if FBSDKAccessToken.current() != nil {
            if headers.count > 1 {
                headers.remove(at: 1)
            }
            self.headers.append("Facebook")
            
            if rows.count > 1 {
                rows.remove(at: 1)
            }
            
            let albumsNames = FacebookAlbumReference.albums.map { (album) -> String in
                return album.name
            }
            self.rows.append(albumsNames)
        } else {
            self.headers = [self.headers[0]]
            self.rows = [self.rows[0]]
            self.tableView.reloadData()
        }
    }
    
    /// Update photo albums of Facebook
    func checkFacebookInformation(sender: Any?) {
        if sender is AlbumsTableViewController {
            guard FacebookAlbumReference.albums.count == 0 else { return }
        }
        
        if FBSDKAccessToken.current() != nil {
            self.detailViewController?.activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            PhotosServices.init().getPhotosForAllAlbuns(completion: { (_, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.detailViewController?.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.updateHeaders()
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    /// Add Facebook albums info
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFacebookInformation(sender: self)
        updateHeaders()
        facebookDict = UserDefaultsManager.getFacebookAlbuns()
    }
}

extension AlbumsTableViewController: UITableViewDataSource, UITableViewDelegate {
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
            if localImagesDict[(cell?.textLabel?.text?.lowercased())!] == true {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
        
        // Load the chekcmarks for Facebook albums
        if indexPath.section == 1 {
            let key = FacebookAlbumReference.albums[indexPath.row].idAlbum
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
            // Local Cells
            if indexPath.section == 0 {
                let category = rows[indexPath.section][indexPath.row].lowercased()
                
                let json = LoadJson.shared.json!
                self.imageModel = ImageModel.init(json: json, categories: [CategoryPhotos(rawValue: category)!])
                if let localPhotos = self.imageModel?.photos {
                    detailViewController?.photos = localPhotos
                    detailViewController?.collectionView.reloadData()
                }
            }
            
            // Facebook Cells
            if indexPath.section == 1 {
                detailViewController?.photos = FacebookAlbumReference.albums[indexPath.row].photos!
                detailViewController?.collectionView.reloadData()
            }
        }
    }
    
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
                facebookDict[FacebookAlbumReference.albums[indexPath.row].idAlbum] = true
            } else {
                facebookDict[FacebookAlbumReference.albums[indexPath.row].idAlbum] = false
            }
            UserDefaultsManager.saveFacebookAlbuns(albums: facebookDict)
        }
        splitRootViewController?.photoWallViewController?.reloadCollectionViewSource(option: .fromBegining)
    }
}
