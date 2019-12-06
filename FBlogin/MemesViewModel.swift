//
//  MemesViewModel.swift
//  PokeMeme
//
//  Created by Chelsea Cui on 11/5/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import Foundation

class MemesViewModel {
  
  var memes = [Meme]()
  var data = Data()
  
  func numberOfRows() -> Int {
     return memes.count
   }
   
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    // Your code here
    if indexPath.row < memes.count && indexPath.row >= 0 {
      return memes[indexPath.row].userName
    }
    return ""
    
   }
  
  func refresh(completion: @escaping () -> Void) {
  }
  
  func fetchMemeData(_ params: String) {
    let url = "https://poke-meme-67442.herokuapp.com/v1/memes?" + params
    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
       guard let data = data else {
         print("Error: No data to decode")
         return
       }
       self.data = data
       semaphore.signal()
     }

     task.resume()
     semaphore.wait()
  }
  
  // api FETCH memes
  func loadMemes(_ data: Data) {
     let jsonDecoder = JSONDecoder()
     self.memes = try! jsonDecoder.decode([Meme].self, from: data)
  }
  
  

}
