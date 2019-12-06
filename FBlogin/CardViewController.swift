//
//  CardViewController.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 11/4/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import Foundation
import UIKit

class CardViewController: UIViewController {
  
  @IBOutlet weak var handleArea: UIView!
  
  @IBOutlet weak var stationName: UILabel!
  
  @IBOutlet weak var stationIntro: UILabel!
  
  @IBOutlet weak var mayor: UILabel!
  
  @IBOutlet weak var bestMeme: UIImageView!
  
  @IBOutlet weak var sumOfLikes: UILabel!
  
  var id: String?
  var rankings: [UserRank]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  @IBAction func viewMemes(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "MemeListScreen", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "MemeListViewController") as! MemeListViewController
    vc.stationName = stationName.text!
    vc.stationId = id!
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func viewLeaderBoard(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "LeaderBoardScreen", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "LeaderBoardViewController") as! LeaderBoardViewController
    vc.stationName = stationName.text!
    vc.stationId = id!
    vc.rankings = rankings
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
