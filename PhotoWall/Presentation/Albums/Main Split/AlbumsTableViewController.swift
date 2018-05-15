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
    
    @IBOutlet weak var tableView: UITableView!
    
    // Headers and rows
    let headers: [String] = ["Local", "Facebook", "Instagram"]
    let rows: [[String]] = [["City", "Default", "Nature"], ["Feed", "Album 1", "Album 2"], ["Your photos"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allows selecing multiple albums
        self.tableView.allowsMultipleSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext,
                   with coordinator: UIFocusAnimationCoordinator) {
//        self.splitRootViewController?.facebookViewController?.label.text = self.rows[(context.nextFocusedIndexPath?.section)!][(context.nextFocusedIndexPath?.row)!]
    }
    
    /// Change Detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            //Album Facebook detail view
//            self.splitRootViewController?.showDetailViewController(
//                (splitRootViewController?.facebookViewController)!, sender: self)
//        }
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
    }
}
