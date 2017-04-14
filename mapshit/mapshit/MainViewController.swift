//
//  MainViewController.swift
//  mapshit
//
//  Created by juran_k on 4/11/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit
import Lottie
import MapKit
import CoreLocation

class MainViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet var sideOptionView: UITableView!
    @IBOutlet weak var favoriteButton: UIView!
    @IBOutlet weak var detailViewLabel: UILabel!
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var detailViewInfo: UITextView!
    @IBOutlet var settingView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var menuOn = false
    var hamburgerMenuButton: LOTAnimationView!
    let hamburgerMenuFrame = CGRect(x: 0, y: -5, width: 75, height: 75)
    var currentHamburgerMenuFrame : CGRect!
    var effect: UIVisualEffect!
    var sideOptionViewFrame : CGRect!
    var currentUserLocation: CLLocation!
    var initialZoomIn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.",isFavorited: true)
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.",isFavorited: false)
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.",isFavorited: false)
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", isFavorited: false)
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.",isFavorited: false )
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.delegate = self
//        let center = CLLocationCoordinate2D(latitude: 40.7128, longitude: 74.0059)
//        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
//        mapView.setRegion(region, animated: false)
        // Do any additional setup after loading the view.
        
        currentHamburgerMenuFrame = hamburgerMenuFrame
        sideOptionViewFrame = sideOptionView.frame
        sideOptionViewFrame.size.height = self.view.frame.size.height
        sideOptionView.frame = CGRect(x:sideOptionViewFrame.origin.x-sideOptionViewFrame.size.width,y:sideOptionViewFrame.origin.y,width: sideOptionViewFrame.size.width, height: sideOptionViewFrame.size.height)
        sideOptionView.alpha = 0
        self.view.addSubview(sideOptionView)
        
        addHamburgerMenuButton(on: menuOn)
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        detailView.layer.cornerRadius = 5
        
        
        
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 100)
        mapView.setRegion(coordinateRegion, animated: true)
        print(coordinateRegion)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
    
    func addLocationData(loc:Capital) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let location = Location(context: context)
        location.name = loc.title
        location.info = loc.info
        location.longitude = loc.coordinate.longitude
        location.latitude = loc.coordinate.latitude
        location.isFavorited = loc.isFavorited
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //Hamburger menu addition
    func addHamburgerMenuButton (on: Bool) {
        if hamburgerMenuButton != nil {
            currentHamburgerMenuFrame = hamburgerMenuButton.frame
            hamburgerMenuButton.removeFromSuperview()
            hamburgerMenuButton = nil
            
        }
        
        let animation = menuOn ? "buttonOff" : "buttonOn"
        hamburgerMenuButton = LOTAnimationView(name: animation)
        hamburgerMenuButton?.isUserInteractionEnabled = true
        hamburgerMenuButton?.frame = currentHamburgerMenuFrame
        hamburgerMenuButton?.contentMode = .scaleAspectFill
        addMenuToggleRecognizer()
        self.view.addSubview(hamburgerMenuButton!)
//        print(currentHamburgerMenuFrame)
    }
    
    func addMenuToggleRecognizer () {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.toggleMenu(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        hamburgerMenuButton?.addGestureRecognizer(tapRecognizer)
    }
    
    func toggleMenu(recognizer: UITapGestureRecognizer) {
        if !menuOn {
            appearPopOverMenu()
            hamburgerMenuButton?.play(completion: { (success: Bool) in
                self.menuOn = true
                self.addHamburgerMenuButton(on: self.menuOn)
            })
        }
        else {
            disappearPopOverMenu()
            hamburgerMenuButton?.play(completion: { (success: Bool) in
                self.menuOn = false
                self.addHamburgerMenuButton(on: self.menuOn)
            })
        }
        
    }
    
    func appearPopOverMenu() {
        UIView.animate(withDuration: 0.8, animations: {
            self.hamburgerMenuButton.frame.origin = CGPoint(x: self.sideOptionView.frame.width - self.hamburgerMenuButton.frame.width,y:self.hamburgerMenuButton.frame.origin.y)
            self.visualEffectView.effect = self.effect
            self.sideOptionView.frame = self.sideOptionViewFrame
            self.sideOptionView.alpha = 1
        })
        
    }
    func disappearPopOverMenu() {
        UIView.animate(withDuration: 0.8, animations: {
            self.hamburgerMenuButton.frame = self.hamburgerMenuFrame
            self.sideOptionView.frame = CGRect(x:self.sideOptionViewFrame.origin.x-self.sideOptionViewFrame.size.width,y:self.sideOptionViewFrame.origin.y,width: self.sideOptionViewFrame.size.width, height: self.sideOptionViewFrame.size.height)
            self.visualEffectView.effect = nil
            self.sideOptionView.alpha = 0
        })
        
    }
    
   //map GUI and actions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Capital"
        if annotation is Capital {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                //add default values that are favorited from previous runs
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
                
            }
            return annotationView
        }

        return nil
    }
    
    
    
    @IBAction func detailViewDone(_ sender: Any) {
        animateOut()
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let capital = view.annotation as! Capital
        let placeName = capital.title
        let placeInfo = capital.info
        let favorited = capital.isFavorited
        
        detailViewLabel.text = placeName
        detailViewInfo.text = placeInfo
        visualEffectView.effect = effect
        
        
        animateIn()
        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
//            _ in
//            
//            self.visualEffectView.effect = nil
//        }))
        //        present(ac, animated: true)
        
    }
    //detail View animation in and out
    func animateIn() {
        self.view.addSubview(detailView)
        detailView.center = self.view.center
        
        detailView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        detailView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations:  {
            self.visualEffectView.effect = self.effect
            self.detailView.alpha = 1
            self.detailView.transform = CGAffineTransform.identity
        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.detailView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.detailView.alpha = 0
            self.visualEffectView.effect = nil
        }, completion: { _ in
            self.detailView.removeFromSuperview()
            
        })
    }
    
    
//    func dequeueReusableAnnotationView(withIdentifier: String) ->MKPinAnnotationView? {
//        return nil
//    }
    
    
    //For transition back to tutorial/onboarding
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue)  {
        
    }
//    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        
//        let segue = UnwindMainSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
//        segue.perform()
//    }
//    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
