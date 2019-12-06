//
//  LeaderBoardViewController.swift
//  FBlogin
//
//  Created by Xinwen Liu on 12/3/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UITableViewController {

  var stationName: String?
  var stationId: String?
  var rankings: [UserRank]?

  override func viewDidLoad() {
    super.viewDidLoad()
//    viewModel.fetchUserRankData(stationId!)
    
    self.navigationController?.navigationBar.isHidden = false
    let cellNib = UINib(nibName: "LeaderBoardViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "LeaderBoardCell")
    tableView.estimatedRowHeight = 400
    tableView.rowHeight = UITableView.automaticDimension
    tableView.allowsSelection = false
    
    if let staName = stationName {
      self.title = "Leader Board of \(staName)"
    }
    
    let stations = loadStations()
    for station in stations {
      if (station.id == Int(stationId!)) {
        rankings = station.ranking
      }
    }
  }

  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Your code here
    if rankings == nil {
      return 0
    } else {
      return rankings!.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Your code here
    let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardCell", for: indexPath) as! LeaderBoardViewCell
    let user = rankings![indexPath.row]
    cell.rankNum.text = "\(indexPath.row+1)"
    cell.name.text = "\(user.fname) \(user.lname)"
    cell.likeNum.text = "\(user.total_likes) likes"
    return cell
  }


}
