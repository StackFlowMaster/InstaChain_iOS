//
//  SettingsViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/13.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, BaseViewController {
    
    var viewModel: SettingsViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            viewModel.logout()
        }
    }
}
