//
//  LeaderBoardViewCell.swift
//  FBlogin
//
//  Created by Xinwen Liu on 12/3/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import UIKit

class LeaderBoardViewCell: UITableViewCell {
  @IBOutlet weak var rankNum: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var likeNum: UILabel!
  

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
    
}
