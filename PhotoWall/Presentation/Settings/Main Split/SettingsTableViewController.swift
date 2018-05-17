//
//  SettingsTableViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 14/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController {
    // Controllers
    var detailViewController: SettingsViewController?
    var splitRootViewController: SettingsSplitViewController?
    
    // Rows
    let rowName: [String] = ["Accounts", "Themes", "About"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingsTableViewController: UITableViewDataSource,
UITableViewDelegate {
    
    // Number displayed Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowName.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Settings"
    }

    /// Create table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = rowName[indexPath.row]
        return cell!
    }

    /// Change Detail view
    func tableView(_ tableView: UITableView,
                   didUpdateFocusIn context: UITableViewFocusUpdateContext,
                   with coordinator: UIFocusAnimationCoordinator) {
        if let indexPath = context.nextFocusedIndexPath {
            if indexPath.row == 0 {
                //Accounts detail view
                self.splitRootViewController?.showDetailViewController(
                    (splitRootViewController?.accountViewController)!, sender: self)
            } else if indexPath.row == 1 {
                // Theme detail view
                self.splitRootViewController?.showDetailViewController(
                    (splitRootViewController?.themeViewController)!, sender: self)
            } else if indexPath.row == 2 {
                // About detail view
                self.splitRootViewController?.showDetailViewController(
                    (splitRootViewController?.aboutViewController)!, sender: self)
            }
        }
    }
}
