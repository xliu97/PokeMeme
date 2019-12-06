//
//  LocationTest.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 11/7/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import XCTest
@testable import FBlogin

class LocationTests: XCTestCase {

    func test_getCurrentLocation() {
      //need to set current location to be latitude = 40.445426, longitude = -79.9437277
      let location = Location()
      XCTAssertEqual(location.latitude, 0.00)
      XCTAssertEqual(location.longitude, 0.00)
      location.getCurrentLocation()
      //should be the location specified in simulator
      XCTAssertEqual(location.latitude, 40.445426)
      XCTAssertEqual(location.longitude, -79.9437277)
    }
}
