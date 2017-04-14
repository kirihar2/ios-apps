//
//  ToMainSegueue.swift
//  mapshit
//
//  Created by juran_k on 4/8/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit

class ToMainSegue: UIStoryboardSegue {
    override func perform() {
        scale()
    }
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        //toViewController.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.90)
        toViewController.view.center = originalCenter
        containerView?.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
            fromViewController.view.alpha = 0
            toViewController.view.alpha = 1
            //toViewController.view.transform = CGAffineTransform.identity
        }
            , completion: { success in
                fromViewController.present(toViewController, animated: false, completion: nil)
                
        })
        
    }
}

class UnwindMainSegue: UIStoryboardSegue {

    override func perform() {
        scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
            fromViewController.view.alpha = 0
            toViewController.view.alpha = 1
        }
            , completion: { success in
                fromViewController.dismiss(animated: false, completion: nil)
                
        })
        
    }
}
