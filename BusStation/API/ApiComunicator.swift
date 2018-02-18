//
//  ApiComunicator.swift
//  BusStation
//
//  Created by Mirzac Andrei on 09.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import Foundation
import Alamofire
import MapKit
import SwiftyJSON

class ApiCommunicator {
    
    fileprivate var dataBaseManager:SQLiteManager
    fileprivate var jsonManager:JSONManager
    var queue = DispatchQueue.global(qos: .utility)
    
    init () {
        dataBaseManager = SQLiteManager()
        jsonManager = JSONManager()
    }
    
    func loadStationNamesBy(_ query:String,completion:@escaping (_ results:[String])->Void) {
        queue.async {
            let stationNames = self.dataBaseManager.fetchDataWithOccurenceOf(query, columnName: DBColumnName.StopName)
            DispatchQueue.main.async(execute: {
                completion(stationNames)
            })
        }
    }
    
    func getStationsNear(_ location:CLLocationCoordinate2D, completion:@escaping (_ results:[StopPoint])->Void){
        
        let url = Router.stationNearMe(location).urlRequest?.url?.absoluteString
        Alamofire.request(url!, method: .get).responseData(completionHandler:{ response in
            if let data = response.result.value {
                let json = JSON(data:data)
                let stations = self.jsonManager.busStations(json["stopPoints"])
                completion(stations)
            } else {
                completion([StopPoint]())
            }
        })
    }
    
    func getStationsBy(_ query:String,completition:@escaping (_ results:[StopPoint],_ query:String)->Void) {
        
        let ids = dataBaseManager.fetchDataWithOccurenceOf(query, columnName: DBColumnName.NaptanID)
        let pathList = Helpers.createCommaSepStringsFrom(ids)

        for item in pathList {
            let url = Router.stationsByIds(item).urlRequest?.url?.absoluteString
            Alamofire.request(url!, method: .get).responseData(completionHandler: { response in

                if (response.result.error == nil) {
                    let json = JSON(data: response.result.value!)
                    let items = self.jsonManager.busStations(json)
                    completition(items, query)
                } else {
                    print((String(describing: response.result.error)))
                }
            })
        }
    }
    
    func getBusArrivalsFor(_ stationID:String, completion: @escaping (_ results:[BusArrival])->Void) {
        let url = Router.stationBusArrival(stationID).urlRequest?.url?.absoluteString
         Alamofire.request(url!, method: .get).responseData(completionHandler:{ response in
            if let data = response.result.value {
                let json = JSON(data:data)
                let busArrivals = self.jsonManager.busArrivals(json)
                completion(busArrivals)
            } else {
                completion([BusArrival]())
            }
        })
    }
}

