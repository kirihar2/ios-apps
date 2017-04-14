//
//  MainViewController.swift
//  mapshit
//
//  Created by juran_k on 4/9/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit
import Lottie

class MainViewController: UIViewController {
    
    
    var menuOn = false
    var hamburgerMenuButton: LOTAnimationView!
    let hamburgerMenuFrame = CGRect(x: 0, y: 10, width: 75, height: 75)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHamburgerMenuButton(on: menuOn)
        // Do any additional setup after loading the view.
    }
    
    func addHamburgerMenuButton (on: Bool) {
        if hamburgerMenuButton != nil {
            hamburgerMenuButton.removeFromSuperview()
            hamburgerMenuButton = nil
        }
        let animation = on ? "buttonOff" : "buttonOn"
        
        hamburgerMenuButton = LOTAnimationView(name: animation)
        
        hamburgerMenuButton?.isUserInteractionEnabled = true
        
        hamburgerMenuButton?.frame = hamburgerMenuFrame
        
        hamburgerMenuButton?.contentMode = .scaleAspectFill
        
        self.view.addSubview(hamburgerMenuButton)
        
    }
    
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue)  {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
        let segue = UnwindMainSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
