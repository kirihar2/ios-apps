//
//  ViewController.swift
//  smart run
//
//  Created by juran_k on 1/23/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    //var pageViewController: UIPageViewController!
    var pageTitles: [String]!
    var pageImages: [String]!
    var routeMapVC: RouteMapViewController!
    @IBAction func GoToMapView(_ sender: Any) {
        let routeMapVC = self.storyboard?.instantiateViewController(withIdentifier: "RouteMapView") as! RouteMapViewController
        self.navigationController?.pushViewController(routeMapVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = false

        pageTitles = ["this" , "that"]
        pageImages = ["background" , "sliceBackground"]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector (launchSetting))
        self.navigationItem.title = "I am running!"
        
        

    }
    func launchSetting (){
        let SettingVC = self.storyboard?.instantiateViewController(withIdentifier: "Setting") as! ViewController
        present(SettingVC,animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

