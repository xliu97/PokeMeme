//
//  ViewController.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 10/20/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, LoginButtonDelegate {
  
  var profilePhoto: UIImage?
  var userToken: String?
  var userName: String?
  var userID: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true;
    let btnFBLogin = FBLoginButton()
    btnFBLogin.permissions = ["public_profile", "email"]
    btnFBLogin.delegate = self
    btnFBLogin.center = CGPoint(x: view.center.x, y: view.center.y + 200);
    view.addSubview(btnFBLogin)
    
    if let token = AccessToken.current {
      print("already logged in ")
      userToken = token.userID
      loadUser()
      fetchProfile(userID: userToken!)
      fetchName(userID: userToken!)
    } else{
      print("logged out")
    }
  }
  
  func fetchProfile(userID: String){
    print("fetching profile")
    let fbProfileUrl = URL(string:"http://graph.facebook.com/\(userID)/picture?type=large")
    if let data = try? Data(contentsOf: fbProfileUrl!)
    {
      profilePhoto = UIImage(data: data)
      print("successfully fetched profile")
    } else{
      print("error when fetching profile")
    }
  }
  
  func fetchName(userID: String){
    print("fetching name")
    GraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name"]).start (completionHandler: { (connection, result, error) -> Void in
        if (error == nil){
          let dict = result as! NSDictionary
          let fname = dict["first_name"] as? String
          let lname = dict["last_name"] as? String
          self.userName = fname! + " " + lname!
          print("successfully fetched name")
          let myPost = Post(first_name: fname!, last_name: lname!, fb_access_token: userID, photo: "http://graph.facebook.com/\(userID)/picture?type=large")
          self.submitPost(post: myPost)
          self.performSegue(withIdentifier: "toMapView", sender: self)
        } else{
        print("error when fetching name")
      }
    })
  }
  
  func submitPost(post: Post) {
    let parameters = ["first_name": post.first_name, "last_name": post.last_name, "fb_access_token":post.fb_access_token, "photo": post.photo] as [String : Any]

      Alamofire.request("https://poke-meme-67442.herokuapp.com/v1/users", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString {
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
  
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    if error != nil{
      print("error occurred during login")
    } else if result!.isCancelled {
      print("login cancelled")
    } else{
      print("successful login")
      self.performSegue(withIdentifier: "toMapView", sender: self)
      // should set mapViewController to the root controller if logged in
    }
  }

  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
  }
  
  // pass profile photo to map view Controller
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let mapViewController = segue.destination as? MapViewController,
      let image = profilePhoto
      else {
        return
    }
    mapViewController.profilePhoto = resizeImage(image: image, newWidth: 50)
    mapViewController.userID = userID
    mapViewController.userName = userName
    mapViewController.userToken = userToken
  }
  
  // resize image without losing quality
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil}
    UIGraphicsEndImageContext()
    return newImage
  }
  
  func loadUser() {
    let url = "https://poke-meme-67442.herokuapp.com/v1/users?token=" + userToken!
    let githubURL: NSURL = NSURL(string: url)!
    let data = NSData(contentsOf: githubURL as URL)!
    
    let swiftyjson = try? JSON(data: data as Data)
    
    if let users = swiftyjson {
      for user in users {
        let u = user.1
        self.userID = u["id"].int!
      }
    }
  }
}

