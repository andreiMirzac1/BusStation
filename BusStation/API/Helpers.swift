//
//  Helpers.swift
//  BusStation
//
//  Created by Mirzac Andrei on 07.01.16.
//  Copyright © 2016 Mirzac Andrei. All rights reserved.
//

import Foundation
import Alamofire
import MapKit


struct Helpers {
    
    static let maxIDsQuery = 20
    static func createCommaSepStringsFrom(_ list:[String])->[String] {
        
        var pathList = [String]()
        var idsLimit = 0
        var commaSepIds = String()
        for (index,item) in list.enumerated() {
            let withComma = item + ","
            commaSepIds += index == list.count-1 ? item : withComma
            if idsLimit == maxIDsQuery || index == list.count-1{
                pathList.append(commaSepIds)
                commaSepIds = ""
                idsLimit = 0
            }else {
                idsLimit += 1
            }
        }
        return pathList
    }
}

extension Date {
    func stringFromDateWithFormat(_ format:String)->NSString {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self) as NSString
    }
}
extension String
{
    func replace(_ target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    func contains(_ find:String)->Bool{
        return self.range(of: find, options: NSString.CompareOptions.caseInsensitive) != nil
    }
}


enum DBColumnName:String {
    case NaptanID = "Naptan_Atco"
    case StopName = "Stop_Name"
}

enum Router: URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest {
        let results: (path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .stationsByQuery(let query):
                let params = ["app_key":Router.developerKey,
                              "app_id":Router.appId,
                              "query":query,
                              "faresOnly":"False",
                              "modes":"bus"]
                return ("/StopPoint/Search/",params as [String : AnyObject])
            case .stationsByIds(let pathWithIDs):
                let params = ["app_key":Router.developerKey,"app_id":Router.appId]
                return ("/StopPoint/\(pathWithIDs)",params as [String : AnyObject])
            case .stationNearMe(let location):
                let params = [
                    "lat":String(location.latitude),
                    "lon":String(location.longitude),
                    "stopTypes":Router.stopTypes,
                    "modes":"bus",
                    "radius":"400",
                    "app_key":Router.developerKey,
                    "app_id":Router.appId]
                return ("/StopPoint",params as [String : AnyObject])
            case .stationBusArrival(let stationId):
                let params = ["app_key":Router.developerKey,"app_id":Router.appId]
                return ("/StopPoint/\(stationId)/Arrivals",params as [String : AnyObject])
            }
        }()
        
        let url = try Router.baseURL.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(results.path))
        return try URLEncoding.default.encode(urlRequest, with: results.parameters)
    }

    
    static let baseURL = "https://api.tfl.gov.uk"
    static let appId = "6777f885"
    static let developerKey = "9070e050d511dca4908b02a63a78576c"
    static let stopTypes = "CarPickupSetDownArea,NaptanAirAccessArea,NaptanAirEntrance,NaptanAirportBuilding,NaptanBusCoachStation,NaptanBusWayPoint,NaptanCoachAccessArea,NaptanCoachBay,NaptanCoachEntrance,NaptanCoachServiceCoverage,NaptanCoachVariableBay,NaptanFerryAccessArea,NaptanFerryBerth,NaptanFerryEntrance,NaptanFerryPort,NaptanFlexibleZone,NaptanHailAndRideSection,NaptanLiftCableCarAccessArea,NaptanLiftCableCarEntrance,NaptanLiftCableCarStop,NaptanLiftCableCarStopArea,NaptanMarkedPoint,NaptanMetroAccessArea,NaptanMetroEntrance,NaptanMetroPlatform,NaptanMetroStation,NaptanOnstreetBusCoachStopCluster,NaptanOnstreetBusCoachStopPair,NaptanPrivateBusCoachTram,NaptanPublicBusCoachTram,NaptanRailAccessArea,NaptanRailEntrance,NaptanRailPlatform,NaptanRailStation,NaptanSharedTaxi,NaptanTaxiRank,NaptanUnmarkedPoint"
    
    case stationsByQuery(String)
    case stationsByIds(String)
    case stationNearMe(CLLocationCoordinate2D)
    case stationBusArrival(String)
    
}
