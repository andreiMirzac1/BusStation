//
//  SQLiteManager.swift
//  BusStation
//
//  Created by Mirzac Andrei on 26.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import Foundation

class SQLiteManager {
    
    var database:FMDatabase
    
    init() {
        if let filePath = Bundle.main.path(forResource: "BusStation", ofType: "sqlite"){
            database = FMDatabase(path:filePath)
            if !database.open() {
                print("Unable to open database")
            }
        }else {
            print("Unable find database")
            database = FMDatabase()
        }
    }
    deinit{
        database.close()
    }
    
    func fetchDataWithOccurenceOf(_ stopName:String,columnName:DBColumnName)->[String]{
        
        let escapedStopName = stopName.replace("'", withString: "''")
        var query = String()
        var list = [String]()
        switch columnName {
        case DBColumnName.StopName:
            query = "SELECT \(columnName.rawValue) FROM BusStation WHERE Stop_Name LIKE \'%\(escapedStopName)%\' group by Stop_Name order by length(Stop_Name)"
            break
        case DBColumnName.NaptanID:
            query = "SELECT \(columnName.rawValue) FROM BusStation WHERE Stop_Name LIKE \'%\(escapedStopName)%\'"
            break
        }
        
        let results = database.executeQuery(query,withArgumentsIn: nil)
        if let rs = results{
            while rs.next()
            {
                list.append(rs.string(forColumn: columnName.rawValue))
            }
        }
        return list
    }
}

//CODE FOR CREATING SQL DB from JSON file//////////////////////////////
//    private  func jsonFrom(fileName:String)->JSON{
//
//        if  let path =  NSBundle.mainBundle().pathForResource(fileName, ofType:"json"){
//            if let data = NSData(contentsOfFile: path){
//                return JSON(data: data)
//            }
//        }
//        return nil
//    }
//    private func formatBusStation(var name:String)->String{
//
//        print("before:\(name)")
//        name = name.stringByReplacingOccurrencesOfString(">", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        name = name.stringByReplacingOccurrencesOfString("<", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        name = name.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        name = name.stringByReplacingOccurrencesOfString("  ", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        name = name.lowercaseString
//        name = name.capitalizedString
//        return name
//    }
//}
//    func createDB(){
//        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
//        let fileURL = documents.URLByAppendingPathComponent("BusStation.sqlite")
//        print(fileURL)
//        let database = FMDatabase(path: fileURL.path)
//
//        if !database.open() {
//            print("Unable to open database")
//            return
//        }
//
//        do {
//            try database.executeUpdate("DROP TABLE IF EXISTS BusStation;", values: nil)
//            try database.executeUpdate("create table BusStation (Stop_Name text, Naptan_Atco text, Location_Easting text, Location_Northing text, Heading text, Stop_Area text)", values: nil)
//            let json = jsonFrom("BusStopLocations")
//
//            for (_,subJson) in json {
//
//                var  name = subJson["Stop_Name"].stringValue
//                name = formatBusStation(name)
//                let naptanID = subJson["Naptan_Atco"].stringValue
//                let easting = subJson["Location_Easting"].stringValue
//                let northing = subJson["Location_Northing"].stringValue
//                let heading = subJson["Heading"].stringValue
//                let stopArea = subJson["Stop_Area"].stringValue
//                try database.executeUpdate("insert into BusStation (Stop_Name, Naptan_Atco, Location_Easting, Location_Northing, Heading, Stop_Area) values (?, ?, ?, ?, ?, ?)", values: [name, naptanID, easting, northing, heading, stopArea])
//            }
//
//        } catch let error as NSError {
//            print("failed: \(error.localizedDescription)")
//        }
//
//
//        database.close()
//    }
//CODE FOR CREATING SQL DB from JSON file//////////////////////////////
