//
//  ResultsTableController.swift
//  BusStation
//
//  Created by Mirzac Andrei on 01.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import UIKit

protocol FilterTableViewControllerDelegate{
    func didSelectStation(_ stationName:String)->Void
    
}

class FilterTableViewController: UITableViewController,UISearchBarDelegate{
    
    var delegate:FilterTableViewControllerDelegate?
    var selectedStationName = String()
    var searchBar:UISearchBar!
    var filteredStopPoints = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
      let insetTop = searchBar.frame.height - searchBar.frame.origin.y
        self.tableView.contentInset = UIEdgeInsets(top:insetTop, left: 0, bottom: 0, right: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStopPoints.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")!
        cell.textLabel?.text = filteredStopPoints[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedStationName = filteredStopPoints[indexPath.row]
        delegate?.didSelectStation(selectedStationName)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchQuery = searchBar.text!
        delegate?.didSelectStation(searchQuery)
    }
    

}
