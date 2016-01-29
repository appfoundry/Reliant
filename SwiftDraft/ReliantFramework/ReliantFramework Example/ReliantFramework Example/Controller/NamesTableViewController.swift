//
//  NamesTableViewController.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 29/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import UIKit
import Reliant

class NamesTableViewController: UITableViewController {
    
    let context = relyOn(NamesTableViewControllerContext)()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return context.viewModel.generatedNames?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath)
        cell.textLabel?.text = context.viewModel.generatedNames?[indexPath.row]
        return cell
    }
    
    @IBAction func pulledToRefresh(sender: AnyObject) {
        self.reloadData()
    }
    
    func reloadData() {
        context.viewModel.generateNames { [weak self] (names, error) in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toDetail" {
                if let index = self.tableView.indexPathForSelectedRow?.row, let name = context.viewModel.generatedNames?[index], let nameReceiver = segue.destinationViewController as? NameReceiver {
                    nameReceiver.receiveName(name)
                }
            }
        }
    }
}
