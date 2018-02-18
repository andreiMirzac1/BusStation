//
//  MainTableViewControllerExtensions.swift
//  BusStation
//
//  Created by Mirzac Andrei on 29.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import Foundation
import UIKit

extension MainTableViewController {
    //MARK:UITableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStations.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.cellIdentifier) as! CostumTableViewCell
        let busStation = busStations[indexPath.row]
        cell.configure(busStation, indexRow: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        performSegue(withIdentifier: pushToDetailsVCIndentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BusStationArrivalsController {
            destination.configure(busStations, selectedStation: busStations[selectedCell])
        }
    }
}


extension MainTableViewController:UISearchResultsUpdating {
    //MARK:UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController)
    {
        let text = searchController.searchBar.text!
        
        if(text.count > 3) {
            apiClient.loadStationNamesBy(text, completion: {results in
                let filterController = self.searchController.searchResultsController as! FilterTableViewController
                filterController.filteredStopPoints = results
            })
        }else {
            let filterController = searchController.searchResultsController as! FilterTableViewController
            filterController.filteredStopPoints = [String]()
        }
    }
}
