//
//  JSONManagerTests.swift
//  BusStation
//
//  Created by Mirzac Andrei on 29.11.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//


import XCTest

func printItems(_ stopPoints:[StopPoint]){
    
    print("NUMBER OF STATIONS IS  \(stopPoints.count)")
    for stopPoint in stopPoints{
        print("______________________________________________")
        print("name :\(stopPoint.name)")
        print("id :\(stopPoint.stationId)")
        print("lines :\(stopPoint.lines)")
        print("lat :\(stopPoint.lat)")
        print("lon :\(stopPoint.long)")
        print("parentID :\(stopPoint.parentId)")
        print("stopLetter :\(stopPoint.stopLetter)")
        print("Towards :\(stopPoint.towards)")
        print("______________________________________________")
    }
}

class JSONManagerTests: XCTestCase {

    func getJSONDataFromFile(_ fileName:String)->JSON{
        
        if  let path =  Bundle.main.path(forResource: fileName, ofType:"json"){
            if let data = Data(contentsOfFile: path){
                return JSON(data: data)
            }
        }
        return nil
    }
    

    func testReadingFromJSONFile()->Void{
        
        measure(){
       
        }
    }
    
//    func testGetStopPointsWithMultipleIdRequests(){
//        let json = getJSONDataFromFile("multipleIDResponse")
//        let stopPoints = JSONManager.sharedInstance.getStopPointsFromJSON(json)
//        XCTAssertNotNil(stopPoints, "StopID Should not be nil")
//        XCTAssertNotEqual(stopPoints.count, 0, "Should not be equal")
//    }
//    
//    func testGetStopIdsFromJSONShouldNotBeNilorEmpty(){
//        
//        let json = getJSONDataFromFile("JsonSearchQuery")
//        let stopIds = JSONManager.sharedInstance.getStopIdsFromJSON(json)
//        
//        XCTAssertNotNil(stopIds, "StopID Should not be nil")
//        XCTAssertNotEqual(stopIds.count, 0, "Should not be equal")
//        for stopID in stopIds{
//            print("ID = \(stopID)")
//        }
//    }
    
    func testGetStopPointsFromJSONShouldNotBeNilorEmpty(){
        
        let json = getJSONDataFromFile("searchByID")
        let stopPoints = JSONManager.sharedInstance.busStations(json)
        XCTAssertNotNil(stopPoints, "StopID Should not be nil")
        XCTAssertNotEqual(stopPoints.count, 0, "Should not be equal")
        for stopPoint in stopPoints {
            XCTAssertNotEqual(stopPoint.name, "")
            XCTAssertNotEqual(stopPoint.stationId, "")
            XCTAssertNotEqual(stopPoint.lat, "")
            XCTAssertNotEqual(stopPoint.long, "")
            XCTAssertNotEqual(stopPoint.stopLetter, "")
            XCTAssertNotEqual(stopPoint.towards, "")
            XCTAssertNotEqual(stopPoint.lines?.count, 0)
        }
    }
    

//    func testGetStopPointsFromJSONShouldBeEmpty(){
//        let json = getJSONDataFromFile("noMatchesQueryJSONResponse")
//        let stopPoints = JSONManager.sharedInstance.getStopIdsFromJSON(json)
//        XCTAssertNotNil(stopPoints, "Should not be Nil")
//        XCTAssertEqual(stopPoints.count, 0)
//    }
//    
//    func testGetStopIdsFromJSONShouldBeEmpty(){
//        let json = getJSONDataFromFile("noMatchesQueryJSONResponse")
//        let ids = JSONManager.sharedInstance.getStopIdsFromJSON(json)
//        XCTAssertNotNil(ids, "Should not be Nil")
//        XCTAssertEqual(ids.count, 0)
//    }
}
