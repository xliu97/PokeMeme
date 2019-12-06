//
//  FBloginTests.swift
//  FBloginTests
//
//  Created by Chelsea Cui on 11/6/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import XCTest
@testable import FBlogin

class MemeViewModelTests: XCTestCase {

   func test_numberOfRows() {
    let memes = [Meme(id: 1,
                         userName: "Chelsea Cui",
                         station: "iNoodle",
                         meme: "https://s3.amazonaws.com/pokememe-users/meme1573093774059.jpeg",
                         postDate: "2019-11-07T03:25:06.969Z",
                         e1_like: 1,
                         e2_like: 1,
                         e3_like: 1,
                         e4_like: 1),
                 Meme(id: 2, userName: "Jerry Knight",
                          station: "iNoodle",
                          meme: "https://s3.amazonaws.com/pokememe-users/meme1573093774059.jpeg",
                          postDate: "2019-11-07T03:25:06.969Z",
                          e1_like: 99,
                          e2_like: 1,
                          e3_like: 1,
                          e4_like: 1)]
     let viewModel = MemesViewModel()
     viewModel.memes = memes
     
     XCTAssertEqual(viewModel.numberOfRows(), 2)
   }
  
  func test_titleForRowAtIndexPath() {
    let memes = [Meme(id:1,
           userName: "Chelsea Cui",
           station: "iNoodle",
           meme: "https://s3.amazonaws.com/pokememe-users/meme1573093774059.jpeg",
           postDate: "2019-11-07T03:25:06.969Z",
           e1_like: 1,
           e2_like: 1,
           e3_like: 1,
           e4_like: 1),
                 Meme(id:2,
            userName: "Jerry Knight",
            station: "iNoodle",
            meme: "https://s3.amazonaws.com/pokememe-users/meme1573093774059.jpeg",
            postDate: "2019-11-07T03:25:06.969Z",
            e1_like: 99,
            e2_like: 1,
            e3_like: 1,
            e4_like: 1)]
    
      let viewModel = MemesViewModel()
      viewModel.memes = memes
      
      let indexPath1 = IndexPath(row: 0, section: 0)
      XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath1), "Chelsea Cui")
      
      let indexPath2 = IndexPath(row: 1, section: 0)
      XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath2), "Jerry Knight")
      
      let indexPath3 = IndexPath(row: 99, section: 99)
      XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath3), "")
  }
  
  func test_fetchMemeData() {
      let viewModel = MemesViewModel()
      XCTAssertEqual(viewModel.data, Data())
      viewModel.fetchMemeData("1")
      
      XCTAssertNotEqual(viewModel.data, Data())
  }
  
  func test_loadMemes() {
      let viewModel = MemesViewModel()
      let jsonData = """
      [
      {   "id": 1,
          "user_name": "John Doe",
          "station": "iNoodle",
          "image_url": "https://s3.amazonaws.com/pokememe-users/meme1572994338855.jpeg",
          "post_time": "2019-11-04",
          "e1_like": 23,
          "e2_like": 5,
          "e3_like": 0,
          "e4_like": 4
      },
      {    "id": 2,
           "user_name": "Chelsea Cui",
           "station": "iNoodle",
           "image_url": "https://s3.amazonaws.com/pokememe-users/meme1572994338855.jpeg",
           "post_time": "2019-11-04",
           "e1_like": 0,
           "e2_like": 5,
           "e3_like": 0,
           "e4_like": 20
      },
      {   "id": 3,
          "user_name": "Roxanne Zhang",
          "station": "Underground",
          "image_url": "https://s3.amazonaws.com/pokememe-users/meme1572994338855.jpeg",
          "post_time": "2019-11-05",
          "e1_like": 0,
          "e2_like": 1,
          "e3_like": 0,
          "e4_like": 3
      }
      ]
      """.data(using: .utf8)!
      viewModel.loadMemes(jsonData)
      XCTAssertGreaterThanOrEqual(viewModel.memes.count, 3)
      XCTAssertGreaterThanOrEqual(viewModel.memes[0].userName, "John Doe")
  }
   

}
