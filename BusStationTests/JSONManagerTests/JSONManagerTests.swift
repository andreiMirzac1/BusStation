//
//  JSONManagerTests.swift
//  JSONManagerTests
//
//  Created by Mirzac Andrei on 29.11.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import XCTest
@testable import BusStation

class JSONManagerTests: XCTestCase {
    
    func getJSONDataFromFile(fileName:String)->JSON{
        
        if  let path =  NSBundle.mainBundle().pathForResource(fileName, ofType:"json"){
            if let data = NSData(contentsOfFile: path){
                return JSON(data: data)
            }
        }
        return nil
    }
    
    func testparseStopIdsFromJSON(){
        
        let json = getJSONDataFromFile("JsonSearchQuery")
        let stopIds = JSONManager.sharedInstance.parseStopIdsFromJSON(json)
        
        XCTAssertNotNil(stopIds, "StopID Should not be nil")
        XCTAssertNotEqual(stopIds.count, 0, "Should not be equal")
        for stopID in stopIds{
            print("ID = \(stopID)")
        }
    }
    
    func testparseStopPointsFromJSON(){
        
        let json = getJSONDataFromFile("searchByID")
        let stopPoints = JSONManager.sharedInstance.parseStopPointsFromJSON(json)
        XCTAssertNotNil(stopPoints, "StopID Should not be nil")
        XCTAssertNotEqual(stopPoints.count, 0, "Should not be equal")
        for stopPoint in stopPoints {
            
            //            print("name :\(stopPoint.name)")
            //            print("id :\(stopPoint.stationId)")
            //            print("lines :\(stopPoint.lines)")
            //            print("lat :\(stopPoint.lat)")
            //            print("lon :\(stopPoint.long)")
            //            print("parentID :\(stopPoint.parentId)")
            //            print("stopLetter :\(stopPoint.stopLetter)")
            //            print("Towards :\(stopPoint.towards)")
            
            XCTAssertNotEqual(stopPoint.name, "")
            XCTAssertNotEqual(stopPoint.stationId, "")
            XCTAssertNotEqual(stopPoint.lat, "")
            XCTAssertNotEqual(stopPoint.long, "")
            XCTAssertNotEqual(stopPoint.stopLetter, "")
            XCTAssertNotEqual(stopPoint.towards, "")
            XCTAssertNotEqual(stopPoint.lines?.count, 0)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
