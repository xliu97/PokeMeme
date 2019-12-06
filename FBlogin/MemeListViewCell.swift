//
//  MemeListViewCell.swift
//  PokeMeme
//
//  Created by Chelsea Cui on 11/5/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import UIKit
import Alamofire


class MemeListViewCell: UITableViewCell {
  
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var e1_like: UILabel!
    @IBOutlet weak var e2_like: UILabel!
    @IBOutlet weak var e3_like: UILabel!
    @IBOutlet weak var e4_like: UILabel!
    @IBOutlet weak var meme: UIImageView!
    @IBOutlet weak var e1_Button: UIButton!
    @IBOutlet weak var e2_Button: UIButton!
    @IBOutlet weak var e3_Button: UIButton!
    @IBOutlet weak var e4_Button: UIButton!
  
    
    
  var imageViewHeight = NSLayoutConstraint()
  var imageRatioWidth = CGFloat()
  var id: Int!
  var e1_like_count: Int!
  var e2_like_count: Int!
  var e3_like_count: Int!
  var e4_like_count: Int!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  @IBAction func likeButtonTapped(_ sender: UIButton) {
      let semaphore = DispatchSemaphore(value: 0)
      e1_like.textColor = UIColor.orange
      e2_like.textColor = UIColor.orange
      e3_like.textColor = UIColor.orange
      e4_like.textColor = UIColor.orange
      switch sender {
        case e1_Button:
            e1_like_count += 1
            let param = ["e1_like": e1_like_count ?? 0] as [String : Any]
            likeMeme(param, memeId: id)
            semaphore.signal()
            e1_like.text = String(e1_like_count)
            semaphore.wait()
        case e2_Button:
            e2_like_count += 1
            let param = ["e2_like": e2_like_count ?? 0] as [String : Any]
            likeMeme(param, memeId: id)
            semaphore.signal()
            e2_like.text = String(e2_like_count)
            semaphore.wait()
        case e3_Button:
            e3_like_count += 1
            let param = ["e3_like": e3_like_count ?? 0] as [String : Any]
            likeMeme(param, memeId: id)
            semaphore.signal()
            e3_like.text = String(e3_like_count)
            semaphore.wait()
        case e4_Button:
            e4_like_count += 1
            let param = ["e4_like": e4_like_count ?? 0] as [String : Any]
            likeMeme(param, memeId: id)
            semaphore.signal()
            e4_like.text = String(e4_like_count)
            semaphore.wait()
        default:
            break
      }
    
  }
  
  
  func likeMeme(_ param: Parameters?, memeId: Int){
    let url = "https://poke-meme-67442.herokuapp.com/v1/memes" + "/\(memeId)"
    Alamofire.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: nil).responseString {
     response in
     switch response.result {
         case .success:
          print(response)
          break

          case .failure(let error):
           print(error)
          }
     }
  }
    
}
