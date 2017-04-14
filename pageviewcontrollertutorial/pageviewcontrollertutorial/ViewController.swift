//
//  ViewController.swift
//  pageviewcontrollertutorial
//
//  Created by juran_k on 1/23/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    var index = 0
    var headerText = ""
    var imageName = ""
    var descriptionText = ""
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .lightContent
//        
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.image = UIImage(named: imageName)
        
        startButton.isHidden = (index == 0) ? false : true
        startButton.layer.cornerRadius = 5.0
        startButton.layer.masksToBounds = true
    }
    
    
    @IBAction func startPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "DisplayedTutorial")
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

