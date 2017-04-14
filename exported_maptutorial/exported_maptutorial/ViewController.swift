//
//  ViewController.swift
//  exported_maptutorial
//
//  Created by juran_k on 4/9/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit

//
//  ViewController.swift
//  mapshit
//
//  Created by juran_k on 4/4/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit
import MapKit
import paper_onboarding
import Lottie

class ViewController: UIViewController , PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var onboardingView: OnboardingView!

    
    
    var menuOn = false
//    var hamburgerMenuButton: LAAnimationView?
//    let hamburgerMenuFrame = CGRect(x: 0, y: 10, width: 75, height: 75)
    
    
    let images = ["truck","location","phone"]
    var ret = [OnboardingItemInfo]()
    
    let reset = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        addHamburgerMenuButton(on: menuOn)
        
        let backgroundColorOne = UIColor(red: 217/255, green: 50/255, blue: 50/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 50/255, green: 217/255, blue: 50/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 50/255, green: 50/255, blue: 217/255, alpha: 1)
        let backgroundColors = [backgroundColorOne, backgroundColorTwo, backgroundColorThree]
        let titleFont = UIFont(name: "Arial", size: 25)!
        let descriptionFont = UIFont(name: "Arial", size: 18)!
        
        
        for i in 0...images.count-1 {
            ret.append((images[i],images[i],"hi","",backgroundColors[i],UIColor.white,UIColor.white, titleFont,descriptionFont))
        }
        
        onboardingView.dataSource = self
        onboardingView.delegate = self
        
        
        
        //        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        //        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        //        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        //        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        //        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        //        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        
    }
    
    func addHamburgerMenuButton (on: Bool) {
//        if hamburgerMenuButton != nil {
//            hamburgerMenuButton?.removeFromSuperView()
//            hamburgerMenuButton = nil
//        }
//        let animation = on ? "buttonOff" : "buttonOn"
//        
//        hamburgerMenuButton = LAAnimationView.animationNamed(animation)
//        
//        hamburgerMenuButton?.isUserInteractionEnabled = true
//        
//        hamburgerMenuButton?.frame = hamburgerMenuFrame
        
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        return ret[index]
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
        if index == 2 {
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1
            })
        }
    }
    @IBAction func gotStarted(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true,forKey: "onboardingComplete")
        userDefaults.synchronize()
    }
    
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue)  {
        
    }
    
    //going back to the last page on the tutorial
    //not working with defaults check in appdelegate because the view is the main app and there is no onboarding superview....
    //**need more investigation
    //
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
        let segue = UnwindMainSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
}


