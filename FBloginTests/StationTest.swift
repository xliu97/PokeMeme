//
//  StationTest.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 11/7/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import XCTest
@testable import FBlogin

class StationTests: XCTestCase {

  func test_loadStations() {
    let jsonData = """
    [{
    "id":1,
    "name":"iNoodle",
    "longitude":-79.9455855,
    "latitude":40.4433813,
    "introduction":"A magic place on campus providing asian cuisine, rice/noodle bowls, hot/cold boba tea, breakfast. While sometimes there could be some extra crispy stuff accidentally occur in the food, their ramen and poke bowl are super good!",
    "mayor":{
        "id":5,
        "fb_access_token":"104214354402575",
        "first_name":"Chelsea",
        "last_name":"Cui",
        "created_at":"2019-12-06T01:42:50.510Z",
        "updated_at":"2019-12-06T01:42:50.510Z",
        "photo":""
        },
    "ranking":[{"id":5,
              "first_name":"Chelsea",
              "last_name":"Cui",
              "total_likes":10}]
    },{
    "id":2,
    "name":"Underground",
    "longitude":-79.9431901,
    "latitude":40.4454289,
    "introduction":"Coolest place on campus providing comfort food for poor CMU kids. Occassionaly having some cool bands playing here!",
    "mayor":null,
    "ranking":[]
    },{
    "id":3,
    "name":"Hunt Library",
    "longitude":-79.943736,
    "latitude":40.4411172,
    "introduction":"Hmmmm.... Just believe that you are smart and you can pass all the exams!",
    "mayor":{
        "id":5,
        "fb_access_token":"104214354402575",
        "first_name":"Chelsea",
        "last_name":"Cui",
        "created_at":"2019-12-06T01:42:50.510Z",
        "updated_at":"2019-12-06T01:42:50.510Z",
        "photo":""},
    "ranking":[{"id":5,"first_name":"Chelsea","last_name":"Cui","total_likes":8},
               {"id":3,"first_name":"Cindi","last_name":"Liu","total_likes":6}]}
    ]
    """.data(using: .utf8)!
    let stations = parseStations(data: jsonData)
    XCTAssertEqual(stations.count, 3)
    XCTAssertEqual(stations[0].id, 1)
    XCTAssertEqual(stations[0].name, "iNoodle")
    XCTAssertEqual(stations[0].longitude, -79.9455855)
    XCTAssertEqual(stations[0].latitude, 40.4433813)
    XCTAssertEqual(stations[0].mayor?.id, 5)
    XCTAssertEqual(stations[0].mayor?.fname, "Chelsea")
    XCTAssertEqual(stations[0].mayor?.lname, "Cui")
    XCTAssertEqual(stations[0].ranking?[0].id, 5)
    XCTAssertEqual(stations[0].ranking?.count, 1)
    XCTAssertEqual(stations[0].ranking?[0].fname, "Chelsea")
    XCTAssertEqual(stations[0].ranking?[0].lname, "Cui")
    XCTAssertEqual(stations[0].ranking?[0].total_likes, 10)
    XCTAssertEqual(stations[1].id, 2)
    XCTAssertEqual(stations[1].name, "Underground")
    XCTAssertEqual(stations[1].longitude, -79.9431901)
    XCTAssertEqual(stations[1].latitude, 40.4454289)
    XCTAssertEqual(stations[1].introduction, "Coolest place on campus providing comfort food for poor CMU kids. Occassionaly having some cool bands playing here!")
    XCTAssertEqual(stations[1].mayor?.id, nil)
    XCTAssertEqual(stations[1].ranking?[0].fname, nil)
    XCTAssertEqual(stations[2].id, 3)
    XCTAssertEqual(stations[2].name, "Hunt Library")
    XCTAssertEqual(stations[2].longitude, -79.943736)
    XCTAssertEqual(stations[2].latitude, 40.4411172)
    XCTAssertEqual(stations[2].mayor?.id, 5)
    XCTAssertEqual(stations[2].mayor?.fname, "Chelsea")
    XCTAssertEqual(stations[2].mayor?.lname, "Cui")
    XCTAssertEqual(stations[2].ranking?.count, 2)
    XCTAssertEqual(stations[2].ranking?[0].fname, "Chelsea")
    XCTAssertEqual(stations[2].ranking?[0].lname, "Cui")
    XCTAssertEqual(stations[2].ranking?[0].total_likes, 8)
    XCTAssertEqual(stations[2].ranking?[1].fname, "Cindi")
    XCTAssertEqual(stations[2].ranking?[1].lname, "Liu")
    XCTAssertEqual(stations[2].ranking?[1].total_likes, 6)
  }
  
  func test_closestStation() {
    //need to set current location to be latitude = 40.445426, longitude = -79.9437277
    let jsonData = """
    [{
    "id":1,
    "name":"iNoodle",
    "longitude":-79.9455855,
    "latitude":40.4433813,
    "introduction":"A magic place on campus providing asian cuisine, rice/noodle bowls, hot/cold boba tea, breakfast. While sometimes there could be some extra crispy stuff accidentally occur in the food, their ramen and poke bowl are super good!",
    "mayor":{
        "id":5,
        "fb_access_token":"104214354402575",
        "first_name":"Chelsea",
        "last_name":"Cui",
        "created_at":"2019-12-06T01:42:50.510Z",
        "updated_at":"2019-12-06T01:42:50.510Z",
        "photo":""
        },
    "ranking":[{"id":5,
              "first_name":"Chelsea",
              "last_name":"Cui",
              "total_likes":10}]
    },{
    "id":2,
    "name":"Underground",
    "longitude":-79.9431901,
    "latitude":40.4454289,
    "introduction":"Coolest place on campus providing comfort food for poor CMU kids. Occassionaly having some cool bands playing here!",
    "mayor":null,
    "ranking":[]}
    ]
    """.data(using: .utf8)!
    let stations = parseStations(data: jsonData)
    let location = Location()
    location.latitude = 40.4454289
    location.longitude = -79.9431901
    let station = closestStationHelper(location: location, stations: stations)
    XCTAssertEqual(station.id, 2)
    XCTAssertEqual(station.name, "Underground")
    XCTAssertEqual(station.longitude, -79.9431901)
    XCTAssertEqual(station.latitude, 40.4454289)
  }
  
}
