//
//  TitleScene.swift
//  rainfall
//
//  Created by juran_k on 6/8/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import SpriteKit
import GameplayKit

class TitleScene: SKScene {
    let backgroundRain = SKEmitterNode(fileNamed: "TitleRainBackground")
    let frame_width = titleScene.frame.size.width
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        
        backgroundRain?.position = CGPoint() 
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       
    }
}
