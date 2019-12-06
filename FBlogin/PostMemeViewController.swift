//
//  PostMemeViewController.swift
//  FBlogin
//
//  Created by Xinwen Liu on 11/1/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import UIKit
import PhotoEditorSDK
import Alamofire
import AWSS3
import AWSCore

class PostMemeViewController: UITableViewController {

  @IBOutlet weak var locationName: UILabel!
  @IBOutlet weak var caption: UITextField!
  @IBOutlet weak var photo: UIImageView!
  
  var image: UIImage!
  var stations: [Station]!
  var selectedStation: Station!
  var userToken: String!
  var userID: Int!
  //var pevc: PhotoEditViewController!
  
  init?(coder: NSCoder, img: UIImage) {
    self.image = img
    //self.pevc = pevc
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("You must create this view controller with a user.")
  }
  
  
//  convenience init(img: UIImage) {
//    self.init()
//    self.image = img
//  }

//  required init(coder aDecoder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    photo.image = image
    stations = loadStations()
    selectedStation = closestStation(stations:stations)
    locationName.text = selectedStation.name
  }
  
  @IBAction func cancel() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func uploadImageS3() -> String? {
    let semaphore = DispatchSemaphore(value: 0)
    let accessKey = ""
    let secretKey = ""
    let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
    let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    let fileName = "meme\(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()))"
    let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
    do {
      let filePath = fileURL?.path ?? ""
      let imageData = image!.jpegData(compressionQuality: 0.1)
      try imageData!.write(to: URL(fileURLWithPath: filePath), options: .atomic)
    } catch {
      print("error when upload")
      return nil
    }
//    guard let filePath = fileURL?.path else { return }
    

    let url = fileURL
    let remoteName = "\(fileName).jpeg"
    let S3BucketName = "pokememe-users"
    let uploadRequest = AWSS3TransferManagerUploadRequest()!
    uploadRequest.body = url!
    uploadRequest.key = remoteName
    uploadRequest.bucket = S3BucketName
    uploadRequest.contentType = "image/jpeg"
    uploadRequest.acl = .publicRead

    let transferManager = AWSS3TransferManager.default()
//    let transferUtility = AWSS3TransferUtility.S3TransferUtilityForKey(configuration.CALLBACK_KEY.rawValue)
    transferManager.upload(uploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
      if let error = task.error {
        print("Upload failed with error: (\(error.localizedDescription))")
      }
      if task.result != nil {
        let url = AWSS3.default().configuration.endpoint.url
        let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
        print("Uploaded to:\(publicURL)")
        semaphore.signal()
      }
      return nil
    })
    semaphore.wait()
    return "https://s3.amazonaws.com/pokememe-users/\(remoteName)"
  }
  
  @IBAction func done() {
    
    let url = uploadImageS3()
    let parameters = ["station_id": selectedStation.id, "user_id": userID, "image_url":url!] as [String : Any]

    Alamofire.request("https://poke-meme-67442.herokuapp.com/v1/memes", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString {
     response in
     switch response.result {
                     case .success:
                      print(response)
                      break

                      case .failure(let error):
                       print(error)
          }
     }
    
    let secondPresentingVC = self.navigationController?.presentingViewController
    let thirdPresentingVC = secondPresentingVC?.presentingViewController
    let navController = thirdPresentingVC?.presentingViewController as? UINavigationController
    self.navigationController?.dismiss(animated: false, completion: {
      secondPresentingVC?.dismiss(animated: false, completion: {
        thirdPresentingVC?.dismiss(animated: false, completion: {
          let storyboard1 = UIStoryboard(name: "MemeListScreen", bundle: nil)
          let vc1 = storyboard1.instantiateViewController(withIdentifier: "MemeListViewController") as! MemeListViewController
          vc1.stationName = self.selectedStation.name
          vc1.stationId = "\(self.selectedStation.id)"
          
          navController?.pushViewController(vc1, animated: true)
        })
      });
    });

//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//    let navController = UINavigationController(rootViewController: vc)
//    navController.modalPresentationStyle = .fullScreen
//    self.present(navController, animated: true, completion: nil)
//
//    let storyboard1 = UIStoryboard(name: "MemeListScreen", bundle: nil)
//    let vc1 = storyboard1.instantiateViewController(withIdentifier: "MemeListViewController") as! MemeListViewController
//    vc1.stationName = selectedStation.name
//    vc1.stationId = "\(selectedStation.id)"
//
//    navController.pushViewController(vc1, animated: true)

//    let storyboard = UIStoryboard(name: "MemeListScreen", bundle: nil)
//    let vc = storyboard.instantiateViewController(withIdentifier: "MemeListViewController") as! MemeListViewController
//    vc.stationName = selectedStation.name
//    vc.stationId = "\(selectedStation.id)"
//    self.navigationController?.pushViewController(vc, animated: true)
    
//    let imgData = image!.jpegData(compressionQuality: 0.2)!

//    let parameters = ["fb_access_token": "fbToken555", "first_name": "Spencer", "last_name": "Lee"]
//      print(parameters)
//
//      Alamofire.request("https://poke-meme-67442.herokuapp.com/v1/users", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString {
//       response in
//       switch response.result {
//                       case .success:
//                        print(response)
//                        break
//
//                        case .failure(let error):
//                         print(error)
//            }
//       }


//    let parameters = ["Station_id": "\(selectedStation.id)", "User_id": "1"]
    
//    Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key, value) in parameters {
//              multipartFormData.append(value.data(using: .utf8)!, withName: key)
//                }
//            multipartFormData.append(imgData, withName: "image_url",fileName: "meme.jpeg", mimeType: "image/jpeg")
//        },
//    to:"https://poke-meme-67442.herokuapp.com/v1/memes",
//    encodingCompletion: { (result) in
//        switch result {
//        case .success(let upload, _, _):
//
//            upload.uploadProgress(closure: { (progress) in
//                print("Upload Progress: \(progress.fractionCompleted)")
//            })
//
//            upload.responseString { response in
//                 print(response)
//            }
//
//        case .failure(let encodingError):
//            print(encodingError)
//        }
//    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "allStations" {
      if let selectStationViewController = segue.destination as? SelectStationViewController {
        selectStationViewController.callback = { row in
          self.selectedStation = self.stations[row]
          self.locationName.text = self.selectedStation.name
        }
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(indexPath.row)
    if indexPath.row == 1 {
      self.performSegue(withIdentifier: "allStations", sender: tableView)
    }
    tableView.deselectRow(at:indexPath, animated: true)
  }
  
  


}
