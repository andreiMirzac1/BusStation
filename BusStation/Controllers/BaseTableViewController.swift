//
//  BaseTableViewController.swift
//  BusStation
//
//  Created by Mirzac Andrei on 01.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.

import UIKit

class CostumTableViewCell : UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var towards: UILabel!
    @IBOutlet var lines: UILabel!
    @IBOutlet var stopLetter: UILabel!
    
    func configure(_ stopPoint:StopPoint, indexRow:Int) {
        
        name.text = stopPoint.name
        towards.text = "towards \(stopPoint.towards!)"
        stopLetter.text = stopPoint.stopLetter
        for item in stopPoint.lines! {
            lines.text?.append(" \(item)")
        }
        lines.sizeToFit()
    }
}

class BaseTableViewController: UITableViewController {
    
    static let nibName = "CostumTableViewCell"
    static let cellIdentifier = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier:BaseTableViewController.cellIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70;
        
    }
}
