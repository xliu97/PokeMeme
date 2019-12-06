//
//  MapViewController.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 10/27/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//
import Foundation
import SwiftyJSON
import UIKit
import MapKit
import PhotoEditorSDK

class MapViewController: UIViewController, MKMapViewDelegate, PhotoEditViewControllerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  
  let regionRadius: CLLocationDistance = 400
  var profilePhoto: UIImage?
  let location = Location()
  let droppedPin = ProfilePinAnnotation()
  var timer = Timer()
  var userToken: String?
  var userName: String?
  var userID: Int?

  let url = "https://poke-meme-67442.herokuapp.com/v1/stations"
  var memeStations = [Station]()
  
  // Card View ************************************************
  enum CardState {
    case expanded
    case collapsed
  }
  var cardViewController: CardViewController!
  var popUpViewController: PopUpViewController!
  var visualEffectView : UIVisualEffectView!
  let cardHeight: CGFloat = 610
  let cardHandleAreaHeight: CGFloat = 45
  var cardVisible = false
  var nextState: CardState {
    return cardVisible ? .collapsed : .expanded
  }
  var runningAnimations = [UIViewPropertyAnimator]()
  var animationProgressWhenInterrupted: CGFloat = 0
  // ************************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    location.getCurrentLocation()
    let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    centerMapOnLocation(location: initialLocation)
    // drop pin annotation
    mapView.delegate = self
    droppedPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    mapView.addAnnotation(droppedPin)
    memeStations = loadStations()
    plotStationsOnMap()
    scheduledTimerWithTimeInterval()
  }
  
  func scheduledTimerWithTimeInterval(){
    timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: Selector(("resetLocation")), userInfo: nil, repeats: true)
  }
  
  @objc func resetLocation(){
    location.getCurrentLocation()
    let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    centerMapOnLocation(location: initialLocation)
    droppedPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func nullToNil(value : AnyObject?) -> AnyObject? {
      if value is NSNull {
          return nil
      } else {
          return value
      }
  }
  
//  func loadStations(){
//    let githubURL: NSURL = NSURL(string: url)!
//    let data = NSData(contentsOf: githubURL as URL)!
//
//    let swiftyjson = try? JSON(data: data as Data)
//    if let stations = swiftyjson {
//      for station in stations {
//        let s = station.1
//        var st = Station(sid: s["id"].int!, sname: s["name"].string!, slongitude: s["longitude"].double!, slatitude: s["latitude"].double!, sintroduction: s["introduction"].string!)
//
//        if s["mayor"]["id"].stringValue != "" {
//          let m = User(uid: s["mayor"]["id"].int!, ufirst_name: s["mayor"]["first_name"].string!, ulast_name: s["mayor"]["last_name"].string!)
//          st.mayor = m
//        }
//        if s["ranking"].array?.isEmpty == false {
//          var stationRanking = [User]()
//          for item in s["ranking"] {
//            let rk = item.1
//            let user = User(uid: rk["id"].int!, ufirst_name: rk["first_name"].string!, ulast_name: rk["last_name"].string!)
//            stationRanking.append(user)
//          }
//          st.ranking = stationRanking
//        }
//        memeStations.append(st)
//      }
//    }
//    print("Finished loading station data")
//  }
  
  func plotStationsOnMap() {
    for station in memeStations{
      let stationAnnotation = MKPointAnnotation()
      stationAnnotation.title = station.name
      //stationAnnotation.subtitle = station.introduction
      stationAnnotation.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
      mapView.addAnnotation(stationAnnotation)
    }
  }
  
  // customize drop pin - use profilePhoto
  class ProfilePinAnnotation: MKPointAnnotation {}
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if !(annotation is ProfilePinAnnotation) {
        return nil
    }
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") //as? MKPinAnnotationView
    if pinView == nil {
      pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
    }
    if profilePhoto != nil {
      pinView!.image = profilePhoto
    }
    pinView!.canShowCallout = true
    return pinView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if !(view.reuseIdentifier == "pin") {
      for station in memeStations {
        if (station.name == view.annotation!.title){
          setupCard(selectedStation: station)
          break
        }
      }
    }
    else {
      setupMyAccountModal()
    }
  }
  
  func setupMyAccountModal() {
    popUpViewController = PopUpViewController(nibName:"PopUpViewController", bundle:nil)
    popUpViewController.userID = userID
    popUpViewController.name = userName!
    popUpViewController.profile = profilePhoto!
    self.addChild(popUpViewController)
    self.view.addSubview(popUpViewController.view)
  }
  
  
  // display card for each station
  func setupCard(selectedStation: Station) {
    if let card = self.cardViewController {
      card.removeFromParent()
      card.view.removeFromSuperview()
    }
    cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
    cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHeight/2, width: self.view.bounds.width, height: cardHeight)
    
    cardViewController.stationName.text = selectedStation.name
    cardViewController.stationIntro.text = selectedStation.introduction
    cardViewController.id = String(selectedStation.id)
    cardViewController.rankings = selectedStation.ranking
    
//    if let my = selectedStation.mayor {
//      cardViewController.mayor.text = my.fname +  " " + my.lname
//    }
    let (bestMeme, sumLike, userName) = findBestMeme(stationID: selectedStation.id)
    cardViewController.bestMeme.image = bestMeme
    cardViewController.sumOfLikes.text = String(sumLike!)
    cardViewController.mayor.text = userName
    
    self.addChild(cardViewController)
    self.view.addSubview(cardViewController.view)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleCardTap(recognzier:)))
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action:
      
      #selector(MapViewController.handleCardPan(recognizer:)))
    cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
    cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
  }
  
  
  
  // Animation Part, not connected yet
  @objc
  func handleCardTap(recognzier:UITapGestureRecognizer) {
      switch recognzier.state {
      case .ended:
          animateTransitionIfNeeded(state: nextState, duration: 0.9)
      default:
          break
      }
  }
  
  @objc
  func handleCardPan (recognizer:UIPanGestureRecognizer) {
      switch recognizer.state {
      case .began:
          startInteractiveTransition(state: nextState, duration: 0.9)
      case .changed:
          let translation = recognizer.translation(in: self.cardViewController.handleArea)
          var fractionComplete = translation.y / cardHeight
          fractionComplete = cardVisible ? fractionComplete : -fractionComplete
          updateInteractiveTransition(fractionCompleted: fractionComplete)
      case .ended:
          continueInteractiveTransition()
      default:
          break
      }
      
  }
  
  func findBestMeme(stationID: Int) -> (UIImage?, Int?, String?) {
    print(stationID)
    let url = "https://poke-meme-67442.herokuapp.com/v1/memes?station_id=\(stationID)&order_by=like"
    let githubURL: NSURL = NSURL(string: url)!
    let data = NSData(contentsOf: githubURL as URL)!

    var bestMeme: UIImage?
    var userName: String?
    var sumOfLikes = 0
    let swiftyjson = try? JSON(data: data as Data)
    if let memes = swiftyjson {
      for meme in memes {
        let m = meme.1
        let url = NSURL(string: m["image_url"].string!)
        let data = NSData(contentsOf : url! as URL)
        userName = m["user_name"].string!
        bestMeme = UIImage(data : data! as Data)
        sumOfLikes = Int(m["e1_like"].stringValue)! + Int(m["e2_like"].stringValue)! + Int(m["e3_like"].stringValue)! + Int(m["e4_like"].stringValue)!
        break
      }
    }
    return (bestMeme, sumOfLikes, userName)
  }
  
  func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
      if runningAnimations.isEmpty {
          let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
              switch state {
              case .expanded:
                  self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
              case .collapsed:
                  self.cardViewController.view.frame.origin.y = self.view.frame.height + 100
              }
          }
          
          frameAnimator.addCompletion { _ in
              self.cardVisible = !self.cardVisible
              self.runningAnimations.removeAll()
          }
          
          frameAnimator.startAnimation()
          runningAnimations.append(frameAnimator)
          
          let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
              self.cardViewController.view.layer.cornerRadius = 12
          }
          
          cornerRadiusAnimator.startAnimation()
          runningAnimations.append(cornerRadiusAnimator)
    }
  }
  
  func startInteractiveTransition(state:CardState, duration:TimeInterval) {
      if runningAnimations.isEmpty {
          animateTransitionIfNeeded(state: state, duration: duration)
      }
      for animator in runningAnimations {
          animator.pauseAnimation()
          animationProgressWhenInterrupted = animator.fractionComplete
      }
  }
  
  func updateInteractiveTransition(fractionCompleted:CGFloat) {
      for animator in runningAnimations {
          animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
      }
  }
  
  func continueInteractiveTransition (){
      for animator in runningAnimations {
          animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
      }
  }
  
  @IBAction func startPhotoEditor(_ sender: Any) {
    let configuration = Configuration { builder in
      builder.configureCameraViewController { options in
        options.allowedRecordingModes = [.photo]
        options.showCancelButton = true
        options.showFilters = false
      }
    }
    let cameraViewController = CameraViewController(configuration: configuration)
    cameraViewController.dataCompletionBlock = { [unowned cameraViewController] data in
      guard let data = data else {
        return
      }

      let photo = Photo(data: data)
      let photoEditViewController = PhotoEditViewController(photoAsset: photo)
      photoEditViewController.delegate = self as! PhotoEditViewControllerDelegate

      cameraViewController.present(photoEditViewController, animated: true, completion: nil)
    }

    cameraViewController.completionBlock = { image, _ in
      guard let image = image else {
        return
      }

      let photo = Photo(image: image)
      let photoEditViewController = PhotoEditViewController(photoAsset: photo)
      photoEditViewController.delegate = self as! PhotoEditViewControllerDelegate

      cameraViewController.present(photoEditViewController, animated: true, completion: nil)
    }
    
    cameraViewController.cancelBlock = {
      self.dismiss(animated: true, completion: nil)
    }
    
    cameraViewController.modalPresentationStyle = .fullScreen

    present(cameraViewController, animated: true, completion: nil)
  }
  
  //photo editor
  func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    //self.dismiss(animated: true, completion: nil)
    let storyBoard : UIStoryboard = UIStoryboard(name: "PostMeme", bundle:nil)
    let postMemeViewController = storyBoard.instantiateViewController(identifier: "PostMeme", creator: { coder in
      return PostMemeViewController(coder: coder, img: image)
    })
    postMemeViewController.userID = userID
    let navController = UINavigationController(rootViewController: postMemeViewController)
    navController.modalPresentationStyle = .fullScreen
    photoEditViewController.present(navController, animated: true, completion: nil)
  }
  
  func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
    self.dismiss(animated: true, completion: nil)
  }
}
