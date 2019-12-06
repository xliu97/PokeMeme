//
//  MemeModelTests.swift
//  FBloginTests
//
//  Created by Chelsea Cui on 11/6/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//


import XCTest
@testable import FBlogin

class MemeModelTests: XCTestCase {
  
  let meme = Meme(id: 1, userName: "Chelsea Cui",
                  station: "iNoodle",
                  meme: "https://s3.amazonaws.com/pokememe-users/meme1573093774059.jpeg",
                  postDate: "2019-11-07T03:25:06.969Z",
                  e1_like: 1,
                  e2_like: 1,
                  e3_like: 1,
                  e4_like: 1)
  
  
  func test_MemeModel() {
    XCTAssertEqual(meme.id, 1)
    XCTAssertEqual(meme.userName, "Chelsea Cui")
    XCTAssertEqual(meme.station, "iNoodle")
    XCTAssertEqual(meme.meme, "https://s3.amazonaws.com/pokememe-users/meme1573093774059.jpeg")
    XCTAssertEqual(meme.e1_like, 1)
    XCTAssertEqual(meme.e2_like, 1)
    XCTAssertEqual(meme.e3_like, 1)
    XCTAssertEqual(meme.e4_like, 1)
  }

}

