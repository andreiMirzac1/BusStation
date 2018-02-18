 //
 //  JSONManager.swift
 //  BusStation
 //
 //  Created by Mirzac Andrei on 28.11.15.
 //  Copyright © 2015 Mirzac Andrei. All rights reserved.
 //
 
 import Foundation
 import SwiftyJSON
 
 class JSONManager {

    func busArrivals(_ json:JSON)->[BusArrival] {
        
        var arrivals = [BusArrival]()
        for (_,subjson) in json {
            let bArrival = BusArrival(busJSON: subjson)
            arrivals.append(bArrival)
        }
        return arrivals
    }
    
    func busStations(_ json:JSON)->[StopPoint]{
        
        var stopPoints = [StopPoint]()
        
        if json.dictionaryValue.isEmpty {
            for(_,subJson) in json{
                let stP = childrenBusStations(fromJSON: subJson)
                stopPoints += stP
            }
        }else{
            stopPoints += childrenBusStations(fromJSON: json)
        }
        return stopPoints
    }
    
    fileprivate func childrenBusStations(fromJSON parentJson:JSON)->[StopPoint]{
        
        var stopPoints = [StopPoint]()
        let childrenJson = parentJson["children"]
        for(_, subJson) in childrenJson {
            
            if(doesContainBusMode(subJson)){
                let hasChildrens = !subJson["children"].isEmpty
                if(hasChildrens){
                    stopPoints += childrenBusStations(fromJSON: subJson)
                }else{
                    var stopPt = StopPoint(subJson: subJson)
                    if (stopPt.lines!.isEmpty){
                        for line in parentJson["lineGroup"].arrayValue {
                            if line["stationAtcoCode"].string == stopPt.stationId {
                                stopPt.lines = line["lineIdentifier"].arrayValue.map({$0.string!})
                            }
                        }
                    }
                    if stopPt.isValid() {
                        stopPoints.append(stopPt)
                    }
                }
            }
        }
        return stopPoints
    }
    fileprivate func doesContainBusMode(_ json:JSON)->Bool{
        for (_,subJson) in json["modes"] {
            if subJson.stringValue == "bus"{
                return true
            }
        }
        return false
    }
    
    
    //    private func fillMissingLines( stopPt:[StopPoint], json:JSON)->[StopPoint]{
    //
    //        var modifiedPt = stopPt
    //        for index in 0..<modifiedPt.count{
    //
    //            if (stopPt[index].lines!.isEmpty){
    //                for (subJson) in json["lineGroup"].arrayValue{
    //                    if(subJson["stationAtcoCode"].stringValue == modifiedPt[index].stationId){
    //                        modifiedPt[index].lines = subJson["lineIdentifier"].arrayValue.map({$0.string!})
    //                    }
    //                }
    //            }
    //        }
    //        return modifiedPt
    //    }
    
 }
 
