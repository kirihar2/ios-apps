//
//  PageViewController.swift
//  pageviewcontrollertutorial
//
//  Created by juran_k on 1/23/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    let pageHeaders = ["Test 1 for page view controller header", "Test 2 pvc header"]
    let pageImages = ["background", "sliceBackground"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dataSource = self
        
        if let tutorialVC = self.viewControllerAtIndex(index: 0)
        {
            setViewControllers([tutorialVC], direction: .forward, animated: true, completion: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func nextPageWithIndex(index: Int) {
    
    }
    
    func viewControllerAtIndex(index: Int) -> ViewController? {
        if index >= 0 && index < pageHeaders.count {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ViewController {
                vc.imageName = pageImages[index]
                //navigationController?.pushViewController(vc, animated: true)
                vc.headerText = pageHeaders[index]
                vc.index = index
                return vc
            }
            return nil
        }
        else {
            return nil
        }
    }

}
extension PageViewController : UIPageViewControllerDataSource
{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ViewController).index
        index -= 1
        return viewControllerAtIndex(index: index)
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ViewController).index
        index += 1
        return viewControllerAtIndex(index: index)
        
    }
}
