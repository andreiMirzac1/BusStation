//
//  BusStationArrivalsController.swift
//  BusStation
//
//  Created by Mirzac Andrei on 01.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import UIKit
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



class BusStationArrivalsController: UIViewController {
    
    @IBOutlet var mapView:MKMapView!
    @IBOutlet var timeTableViews:UITableView!
    
    var zoomToFitCalled = false
    let locationManager = CLLocationManager()
    let regionRadius:CLLocationDistance = 1000
    
    var apiCommunicator = ApiCommunicator()
    var searchedStations = [StopPoint]()
    var selectedStation = StopPoint()
    var refreshControler:UIRefreshControl!
    var refreshTimeTable:Timer!
    var busArrivals:[BusArrival]{
        didSet{
            if busArrivals.isEmpty == false {
                busArrivals.sort (by: { first,second in
                    let fir = Int(first.timeToStation!)
                    let sec = Int(second.timeToStation!)
                    return fir < sec })
                timeTableViews.reloadData()
            }
        }}
    
    required init?(coder aDecoder: NSCoder) {
        busArrivals = [BusArrival]()
        super.init(coder: aDecoder)
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedStation.name
        self.navigationItem.backBarButtonItem?.title = ""
        refreshControler = UIRefreshControl()
        refreshControler.attributedTitle = NSAttributedString(string:"")
        refreshControler.addTarget(self, action: #selector(BusStationArrivalsController.updateBusArrivals), for: UIControlEvents.valueChanged)
        timeTableViews.addSubview(refreshControler)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        addAllAnnotations()
        timeTableViews.reloadData()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTimeTable = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(BusStationArrivalsController.updateBusArrivals), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimeTable.invalidate()
    }
    
    func updateBusArrivals() {
        apiCommunicator.getBusArrivalsFor(selectedStation.naptanId!, completion: { (results:[BusArrival])->Void in
            DispatchQueue.main.async(execute: {
                self.busArrivals = results
                if results.isEmpty {
                    var busArrival = BusArrival()
                    busArrival.lineName = "No departure next 30 min"
                    self.busArrivals.append(busArrival)
                }
                self.refreshControler.endRefreshing()
            })
        })
    }
    
    func configure(_ searchedStations:[StopPoint],selectedStation:StopPoint){
        self.searchedStations = searchedStations
        self.selectedStation = selectedStation
        updateBusArrivals()
    }
}


class BusStopAnnotation: NSObject, MKAnnotation {
    let title: String?
    let towards: String
    let coordinate: CLLocationCoordinate2D
    let isSelected:Bool
    init(title: String, towards: String, coordinate: CLLocationCoordinate2D, isSelected:Bool) {
        self.title = title
        self.towards = towards
        self.coordinate = coordinate
        self.isSelected = isSelected
        super.init()
    }
    
    var subtitle: String? {
        return towards
    }
}


extension BusStationArrivalsController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        if location.horizontalAccuracy < 0 {
            return
        }
        let iterval = location.timestamp .timeIntervalSinceNow
        if abs(iterval) < 15 && zoomToFitCalled == false {
            self.zoomtoFitMapAnnotationsWith(location.coordinate)
            zoomToFitCalled = true
        }
    }
    
    func centerMapOnLocation(_ location:CLLocation) {
        
        let cordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(cordinateRegion, animated: true)
    }
}

extension BusStationArrivalsController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BusStopAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
                    view.pinTintColor = annotation.isSelected ? MKPinAnnotationView.greenPinColor() : MKPinAnnotationView.redPinColor()
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure) as UIView
                view.pinTintColor = annotation.isSelected ? MKPinAnnotationView.greenPinColor() : MKPinAnnotationView.redPinColor()
                
            }
            return view
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    }
    func addAllAnnotations() {
        for item in searchedStations {
            let isSelected = item.naptanId == selectedStation.naptanId ? true:false
            let annotation = annotationFrom(item ,isSelected: isSelected)
            mapView.addAnnotation(annotation)
        }
    }
    
    func annotationFrom(_ busStation:StopPoint, isSelected:Bool)->MKAnnotation {
        let lat = Double(busStation.lat!)!
        let long = Double(busStation.long!)!
        let cordinate = CLLocationCoordinate2DMake(lat,long)
        let annotation = BusStopAnnotation(title: busStation.name!, towards: busStation.towards!, coordinate:cordinate, isSelected:isSelected)
        return annotation
    }
    
    func zoomtoFitMapAnnotationsWith(_ userLocation:CLLocationCoordinate2D){
        
        if mapView.annotations.isEmpty {return}
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, userLocation.latitude)
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, userLocation.longitude)
        
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, userLocation.latitude)
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, userLocation.longitude)
        
        for anotation  in  mapView.annotations {
            
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, anotation.coordinate.latitude)
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, anotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, anotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, anotation.coordinate.longitude)
        }
        var region = MKCoordinateRegion()
        
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1
        region = mapView .regionThatFits(region)
        mapView .setRegion(region, animated: true)
    }
    
}

extension BusStationArrivalsController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusArrivalCellIdentifier")
        cell!.textLabel!.text = busArrivals[indexPath.row].lineName
        cell!.detailTextLabel!.text = busArrivals[indexPath.row].timeInMin
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busArrivals.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        let  date = Date().stringFromDateWithFormat("H:mm") as String
        return "Last update: \(date)"
    }
}

