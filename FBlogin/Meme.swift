//
//  Meme.swift
//  PokeMeme
//
//  Created by Chelsea Cui on 11/5/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import Foundation
import UIKit

struct Meme: Decodable {
  let id: Int
  let userName: String
  let station: String
  let meme: String
  let postDate: String
  let e1_like: Int
  let e2_like: Int
  let e3_like: Int
  let e4_like: Int
  
  enum CodingKeys : String, CodingKey {
    case id
    case userName = "user_name"
    case station
    case meme = "image_url"
    case postDate = "post_time"
    case e1_like
    case e2_like
    case e3_like
    case e4_like
  }
}
