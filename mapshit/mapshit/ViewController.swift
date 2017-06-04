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


class ViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var onboardingView: OnboardingView!

    
    let images = ["truck","location","phone"]
    var ret = [OnboardingItemInfo]()
    
    var resetValue = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        
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
    

    //going back to the last page on the tutorial 
    //not working with defaults check in appdelegate because the view is the main app and there is no onboarding superview....
    //**need more investigation
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        
    }


}

