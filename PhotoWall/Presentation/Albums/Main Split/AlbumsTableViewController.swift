//
//  AlbumsTableViewController.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/15/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UIViewController {
    // Controllers
    //var detailViewController: 
    var splitRootViewController: AlbumsSplitViewController?
    
    // Rows
    let rowName: [String] = ["Facebook"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AlbumsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Number displayed Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Albums"
    }
    
    /// Create table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = rowName[indexPath.row]
        return cell!
    }
    
    /// Change Detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //Album Facebook detail view
            self.splitRootViewController?.showDetailViewController(
                (splitRootViewController?.facebookViewController)!, sender: self)
        }
    }
    
}
