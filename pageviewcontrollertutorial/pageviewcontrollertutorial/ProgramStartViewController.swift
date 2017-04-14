//
//  ProgramStartViewController.swift
//  pageviewcontrollertutorial
//
//  Created by juran_k on 1/23/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit

class ProgramStartViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ShowedTutorial = UserDefaults.standard.bool(forKey: "DisplayedTutorial")
        //if !ShowedTutorial {
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController")
            {
                present(pageViewController, animated: true, completion: nil)
            }
        //}
        //present(pageViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
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
