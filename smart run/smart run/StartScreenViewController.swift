//
//  StartScreenViewController.swift
//  smart run
//
//  Created by juran_k on 1/23/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    var RunningVC: ViewController!
    
    
    @IBAction func StartAction(_ sender: Any) {
        let RunningVC = self.storyboard?.instantiateViewController(withIdentifier: "Running") as! ViewController
        RunningVC.modalTransitionStyle = .flipHorizontal
       // present(RunningVC, animated: true)
        navigationController?.pushViewController(RunningVC,animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        let ud = UserDefaults.standard
        if let firstTimeOpened = ud.object(forKey: "firstTimeOpened") as? Bool {
            let tutorialSkipAC = UIAlertController(title:"Tutorial is available", message: "Would you like to go through the tutorial first?", preferredStyle: .alert)
            tutorialSkipAC.addAction(UIAlertAction(title: "Skip", style: .cancel))
            tutorialSkipAC.addAction(UIAlertAction(title: "Go to Tutorial", style: .default) {[unowned self] _ in
                //call tutorial page view controller and initialize
            })
            self.present(tutorialSkipAC,animated: true)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
