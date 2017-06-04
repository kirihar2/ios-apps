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
import CoreData
import TesseractOCR

class MainViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, G8TesseractDelegate{

    @IBOutlet var addLocationView: UIScrollView!
    
    @IBOutlet weak var addressDisplay: UITextView!
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
    let hamburgerMenuFrame = CGRect(x: -5, y: -5, width: 75, height: 75)
    var currentHamburgerMenuFrame : CGRect!
    var effect: UIVisualEffect!
    var sideOptionViewFrame : CGRect!
    var currentUserLocation: CLLocation!
    var initialZoomIn = false
    var animatingHamburger = false
    var locationsFavortited : [Location] = []
    
    let cellReuseIdentifier = "cell"
    let userDefaults = UserDefaults.standard
    
    var toBeUploadedToServer : [Location] = []
    
    var currentWaitTime = 0
    var isWaiting = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.",isFavorited: true)
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.",isFavorited: false)
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.",isFavorited: false)
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", isFavorited: false)
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.",isFavorited: true )
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
       //only comment out if reseting database
//        deleteAllData(entity: "Location")
        
        if !userDefaults.bool(forKey:  "onboardingComplete") {
            for i in [london, oslo, paris, rome, washington] {
                print(i)
                addLocationData(loc: i)
            }
        }
        
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
        } else {
            locationAuthorizationError()
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.delegate = self
        
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
        
        addCellsToTable()
        self.sideOptionView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        sideOptionView.delegate = self
        sideOptionView.dataSource = self
        
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.dropPinToCenter(gestureRecognizer:)))
        uilgr.minimumPressDuration = 1.5
        
        mapView.addGestureRecognizer(uilgr)
        
        var tessaract = G8Tesseract(language: "eng")
        tessaract?.delegate = self
        tessaract?.charWhitelist = "01234567890"
        tessaract?.image = UIImage(named: "image_sample")
        tessaract?.recognize()
        
        //print(tessaract?.recognizedText)
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
        
        switch status {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        
        default:
            print("Authorization Error")
            locationAuthorizationError()
        }
    }
    //not working as intended 
    //should have a default value to activate when location not turned on
    //if default value is not set then have a alert to change the permission
    private func checkLocationAuthorization() {
        if !CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied,.authorizedWhenInUse:
               locationAuthorizationError()
            case .authorizedAlways:
                print("Access")
            }
        }

    }
   
    func locationAuthorizationError() {
        
//        let alert = UIAlertController(
//            title: "IMPORTANT",
//            message: "Camera access required for capturing photos!",
//            preferredStyle: UIAlertControllerStyle.alert
//        )
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
//            if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 0 {
//                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
//                    DispatchQueue.main.async() {
//                        self.checkCamera() } }
//            }
//            }
//        )
//        present(alert, animated: true, completion: nil)
        
        let aa = UIAlertController(title: "Could not launch application", message: "Must have location to be always allowed for the application to work", preferredStyle: .alert)
        aa.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if !CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied,.authorizedWhenInUse:
                    DispatchQueue.main.async() {
                        self.checkLocationAuthorization() }
                
                case .authorizedAlways:
                    print("Access")
                }
            }
            

            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            })
        )
        aa.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            
        present(aa, animated: true, completion: nil)
    }
    //for debug purpose only*****
    func deleteAllData(entity: String)
    {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        do {
            locationsFavortited = try context.fetch(fetchRequest) as! [Location]
            for i in locationsFavortited {
                context.delete(i)
            }
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
//                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0
            {
                let pm = placemarks?[0]
                self.displayLocationInfo(placemark: pm)
            }
            else
            {
//                print("Problem with the data received from geocoder")
            }
        })
//        print(coordinateRegion)
        locationManager.stopUpdatingLocation()
    }
    func displayLocationInfo(placemark: CLPlacemark?)
    {
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            _ = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            _ = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
             let address1 = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : ""
            let address2 = (containsPlacemark.subThoroughfare != nil) ? containsPlacemark.subThoroughfare : ""
            let currentAddress = address2! + ", " + address1! + ", " + locality! + ", " + postalCode!
            addressDisplay.attributedText = NSAttributedString(string:
                currentAddress
            )
//            print(address1!)
//            print(address2!)
//            print(locality!)
//            print(postalCode!)
//            print(administrativeArea!)
//            print(country!)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to initialize GPS: ", error.localizedDescription)
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
        if !menuOn && !animatingHamburger {

            sideOptionView.allowsSelection = false

            animatingHamburger = true
            appearPopOverMenu()
            hamburgerMenuButton?.play(completion: { (success: Bool) in
                self.menuOn = true
                self.addHamburgerMenuButton(on: self.menuOn)
                
                self.animatingHamburger = false
                self.sideOptionView.allowsSelection = true
            })
        }
        else if menuOn && !animatingHamburger{
            sideOptionView.allowsSelection = false

            animatingHamburger = true
            disappearPopOverMenu()
        
            hamburgerMenuButton?.play(completion: { (success: Bool) in
                self.menuOn = false
                self.addHamburgerMenuButton(on: self.menuOn)
                self.animatingHamburger = false
                self.sideOptionView.allowsSelection = true

            })
        }
        
    }
    
    func appearPopOverMenu() {
        addCellsToTable()
        UIView.animate(withDuration: 0.8, animations: {
            
            self.hamburgerMenuButton.frame.origin = CGPoint(x: self.hamburgerMenuButton.frame.origin.x + self.sideOptionView.frame.width - 0.75*self.hamburgerMenuButton.frame.width ,y:self.hamburgerMenuButton.frame.origin.y)
            self.visualEffectView.effect = self.effect
            self.sideOptionView.frame = self.sideOptionViewFrame
            self.sideOptionView.alpha = 1
            
        }, completion: {_ in
            //animatingHamburger set false in toggleMenu because animation is longer there
        })
        
    }
    func disappearPopOverMenu() {
        
        UIView.animate(withDuration: 0.8, animations: {
            self.hamburgerMenuButton.frame = self.hamburgerMenuFrame
            self.sideOptionView.frame = CGRect(x:self.sideOptionViewFrame.origin.x-self.sideOptionViewFrame.size.width,y:self.sideOptionViewFrame.origin.y,width: self.sideOptionViewFrame.size.width, height: self.sideOptionViewFrame.size.height)
            self.visualEffectView.effect = nil
            self.sideOptionView.alpha = 0
        }, completion: { _ in
            self.animatingHamburger = false
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
        _ = capital.isFavorited
        
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
    
    func dropPinToCenter(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
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
    
    
    //tableview stuff
    
    
    func addCellsToTable() {
        sideOptionView.reloadData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: true))
        do {
            locationsFavortited = try context.fetch(fetchRequest) as! [Location]
//            print(locationsFavortited)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.sideOptionView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        // set the text from the data model
        if let currentLocation = self.locationsFavortited[indexPath.row].name {
            cell.textLabel?.text = currentLocation
        }
        return cell
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationsFavortited.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row < locationsFavortited.count && !animatingHamburger {
            let cell = locationsFavortited[indexPath.row]
            toggleMenu(recognizer: UITapGestureRecognizer())
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2D(latitude: cell.latitude, longitude: cell.longitude), 500, 500)
            mapView.setRegion(coordinateRegion, animated: true)

        }
        
        
    }
    private func tableView(_ tableView: UITableView, didDselectRowAt indexPath: IndexPath) {
        
    }
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }
}
