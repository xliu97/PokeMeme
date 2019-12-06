//
//  PopUpViewController.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 12/3/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class PopUpViewController: UIViewController {
//  @IBOutlet weak var handleArea: UIView!

  @IBOutlet weak var profilePhoto: UIImageView!
  @IBOutlet weak var userName: UILabel!
  
  var userID: Int?
  var profile: UIImage?
  var name: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userName.text = name!
    profilePhoto.image = profile!
  }
  
  @IBAction func viewMyMemes(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "MyMemesScreen", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "MyMemesViewController") as! MyMemesViewController
    vc.userId = userID
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func logout(sender: AnyObject) {
    LoginManager().logOut()
  }
  
  @IBAction func touchOutside(sender: AnyObject) {
    self.removeFromParent()
    self.view.removeFromSuperview()
  }
    
}

