//
//  ApiComunicatorTests.swift
//  BusStation
//
//  Created by Mirzac Andrei on 09.12.15.
//  Copyright © 2015 Mirzac Andrei. All rights reserved.
//

import XCTest


class ApiComunicatorTests: XCTestCase {
    
    func test(){
        let busSt = SQLiteManager()
       let stops =  busSt.busStationsWithOccurenceOf("leyton")
        for item in stops {
            print("Stations: \(item.name)")
        }
    }
    
//    func testGetStopPointsWithBadQuery(){
//        
//        let expectation = expectationWithDescription("...")
//        
//        ApiCommunicator.sharedInstance.getStopPointsFromSearchQuery("adasfasdqwew3", onComplete: { stopPt, error in
//            XCTAssertNotNil(stopPt)
//            XCTAssertEqual(stopPt.count, 0, "list of stopPoints should be equal to zero")
//            
//            expectation.fulfill()
//        })
//        
//        waitForExpectationsWithTimeout(5, handler: { error in
//            
//            if let error = error {
//                print(error.description)
//            }
//        })
//    }
    
//    func testAlamofire(){
//        let url = Router.StopPointsByQuery("Leyton").URLRequest.URLString
//        Alamofire.request(.GET,url).responseXMLDocument({(response) in
//            print(response.result.value)
//        })
//    }
    
//    func testShouldNotContainStopsWithWrongData(){
//        
//        let query = "Leyton Station"
//        ApiCommunicator.sharedInstance.getStopPointsFromSearchQuery(query, onComplete: { stopPt, error in
//            XCTAssertNotNil(stopPt)
//            XCTAssertNotEqual(stopPt.count, 0, "list of stopPoints should not be equal to zero")
//            for item in stopPt {
//                if item.name?.lowercaseString.rangeOfString(query) == nil {
//                    print(item.name)
//                    XCTAssert(false, "stopPoint Name does not contain query string!!")
//                }
//                if(item.lines?.count == 0){
//                    XCTAssert(false, "Lines Should Not Be Empty!!")
//                }
//                if(item.towards == ""){
//                    XCTAssert(false, "Towards Should Not Be Empty!!")
//                }
//            }
//        })
//    }
//    
//    func testGetStopPointsForSucces(){
//        
//        let expectation = expectationWithDescription("...")
//        ApiCommunicator.sharedInstance.getStopPointsFromSearchQuery("Leyton Station", onComplete: { stopPt, error in
//            XCTAssertNotNil(stopPt)
//            XCTAssertNotEqual(stopPt.count, 0, "list of stopPoints should not be equal to zero")
//            printItems(stopPt)
//            expectation.fulfill()
//        })
//        
//        waitForExpectationsWithTimeout(99999, handler: { error in
//            
//            if let error = error {
//                print(error.description)
//            }
//        })
//    }
}
