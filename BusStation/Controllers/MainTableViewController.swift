//
//  MainTableViewController.swift
//  BusStation
//
//  Created by Mirzac Andrei on 01.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

extension MainTableViewController: FilterTableViewControllerDelegate {
    
    func didSelectStation(_ stationName: String) {
        if isValid(stationName) {
            busStations = [StopPoint]()
            apiClient.getStationsBy(stationName, completition: {results,stName in
                if(stationName == stName){
                    self.busStations += results
                }else{
                    self.busStations = results
                }
                self.tableView.reloadData()
                self.searchController.isActive = false
            })
        }
    }
}

class MainTableViewController: BaseTableViewController{
    
    var selectedCell = -1
    let pushToDetailsVCIndentifier = "push"
    var busStations = [StopPoint]()
    var filterTableController:FilterTableViewController!
    var searchController: UISearchController!
    
    let locationManager = CLLocationManager()
    var apiClient = ApiCommunicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        filterTableController = storyBoard.instantiateViewController(withIdentifier: "FilterTableViewController") as! FilterTableViewController
        searchController = UISearchController(searchResultsController: filterTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Bus Station Name or code"
        tableView.tableHeaderView = searchController.searchBar
        
        //searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        filterTableController.searchBar = searchController.searchBar
        searchController.searchBar.delegate = filterTableController
        definesPresentationContext = false
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        filterTableController.delegate = self
    }
    
    @IBAction func  showStopNearMe(_ sender:AnyObject) {
        if let userLocation = locationManager.location{
            apiClient.getStationsNear(userLocation.coordinate, completion: { results in
                DispatchQueue.main.async(execute: {
                    self.busStations = results
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    func isValid(_ query:String)->Bool {
        return query.count < 3 ? false:true
    }
}
