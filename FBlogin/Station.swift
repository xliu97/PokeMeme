//
//  Station.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 11/4/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Station {
  let id: Int
  let name: String
  let longitude: Double
  let latitude: Double
  let introduction: String
  var mayor: User?
  var ranking: [UserRank]?

  init(sid: Int, sname: String, slongitude: Double, slatitude: Double, sintroduction: String) {
    id = sid
    name = sname
    longitude = slongitude
    latitude = slatitude
    introduction = sintroduction
  }
}
  

struct User: Decodable {
  let fname: String
  let lname: String
  let id: Int

  init(uid: Int, ufirst_name: String, ulast_name: String) {
    fname = ufirst_name
    lname = ulast_name
    id = uid
  }
}

struct UserRank: Decodable {
  let fname: String
  let lname: String
  let id: Int
  let total_likes: Int

  init(uid: Int, ufirst_name: String, ulast_name: String, utotal_likes: Int) {
    fname = ufirst_name
    lname = ulast_name
    id = uid
    total_likes = utotal_likes
  }
}

struct Post: Codable {
  let first_name: String
  let last_name: String
  let fb_access_token: String
  let photo: String
}

func parseStations(data: Data) -> [Station] {
  var memeStations = [Station]()
  
  let swiftyjson = try? JSON(data: data as Data)
  if let stations = swiftyjson {
    for station in stations {
      let s = station.1
      var st = Station(sid: s["id"].int!, sname: s["name"].string!, slongitude: s["longitude"].double!, slatitude: s["latitude"].double!, sintroduction: s["introduction"].string!)
      if s["mayor"] != JSON.null {
        let m = User(uid: s["mayor"]["id"].int!, ufirst_name: s["mayor"]["first_name"].string!, ulast_name: s["mayor"]["last_name"].string!)
        st.mayor = m
      }
      if s["ranking"].array != [] {
        var stationRanking = [UserRank]()
        for item in s["ranking"] {
          let rk = item.1
          let user = UserRank(uid: rk["id"].int!, ufirst_name: rk["first_name"].string!, ulast_name: rk["last_name"].string!, utotal_likes: rk["total_likes"].int!)
          stationRanking.append(user)
        }
        st.ranking = stationRanking
      }
      memeStations.append(st)
    }
  }
  
  return memeStations
}

func loadStations() -> [Station]{
  let url = "https://poke-meme-67442.herokuapp.com/v1/stations"
  let githubURL: NSURL = NSURL(string: url)!
  let data = NSData(contentsOf: githubURL as URL)!
  return parseStations(data: data as Data)
}



func closestStationHelper(location: Location, stations: [Station]) -> Station {
  var distance = [Double]()
  
  for s in stations {
    let dist = (location.longitude - s.longitude) * (location.longitude - s.longitude) + (location.latitude - s.latitude) * (location.latitude - s.latitude)
    distance.append(dist)
  }
  
  let minDist = distance.min() ?? 0
  let index = distance.firstIndex(of: minDist) ?? 0
  return stations[index]
}

func closestStation(stations: [Station]) -> Station {
  
  let location = Location()
  location.getCurrentLocation()
  return closestStationHelper(location: location, stations: stations)
//  return Station(sid: 1, sname: "inoodle", slongitude: 123.34, slatitude: 234.34, sintroduction: "")
}

