//
//  DataStructure.swift
//  BusStation
//
//  Created by Mirzac Andrei on 28.11.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import Foundation
import SwiftyJSON

extension StopPoint {
    func isValid()->Bool {
        if towards! == "" ||
            naptanId! == "" ||
            name! == "" ||
            lat! == "" ||
            long! == "" ||
            lines?.count == 0 ||
            stopLetter! == "" ||
            stationId! == "" {
                return false
        }
        return true
    }
}

public struct StopPoint {
    
    var name:String?
    var stationId:String?
    var naptanId:String?
    
    var lat:String?
    var long:String?
    var parentId:String?
    var stopLetter:String?
    var towards:String?
    var lines:[String]?
    
    init(){}
    
    init(subJson:JSON){
        naptanId = subJson["naptanId"].stringValue
        name = subJson["commonName"].stringValue
        stationId = subJson["id"].stringValue
        stopLetter = subJson["stopLetter"].string != nil ? subJson["stopLetter"].string : "None"
        lat = String(format: "%.6f", subJson["lat"].doubleValue)
        long = String(format: "%.6f", subJson["lon"].doubleValue)
        lines = subJson["lineGroup"][0]["lineIdentifier"].arrayValue.map({$0.string!})
        towards = {
            for (_, property) in subJson["additionalProperties"] {
                if let key = property["key"].string{
                    if key == "Towards" {
                        return property["value"].stringValue
                    }
                }
            }
            return "Last Station"
            }()
    }
}

public struct BusStation {
    var name:String?
    var naptanId:String?
    var locationEasting:String?
    var locationNorthing:String?
    var heading:String?
    var stopArea:String?
}

public struct BusArrival {
    
    var vehicleId:String?
    var lineName:String?
    var stationName:String?
    var expectedArrival:String?
    var towards:String?
    var destinationName:String?
    var platformName:String?
    var direction:String?
    var timeInMin:String?
    var timeToStation:String?
    
    init(){}
    
    init(busJSON:JSON) {
        
        lineName = busJSON["lineName"].stringValue
        stationName = busJSON["stationName"].stringValue
        destinationName = busJSON["destinationName"].stringValue
        timeToStation = busJSON["timeToStation"].stringValue
        expectedArrival = busJSON["expectedArrival"].stringValue
        vehicleId = busJSON["vehicleId"].stringValue
        platformName = busJSON["platformName"].stringValue
        direction = busJSON["direction"].stringValue
        timeInMin = {
            let MinToSeconds = 60
            if var seconds = Int(timeToStation!) {
                let minutes = seconds / MinToSeconds
                seconds -= minutes * MinToSeconds
                return "\(minutes)min \(seconds)sec"
            }else {
                return "error"
            }
        }()
    }
}

