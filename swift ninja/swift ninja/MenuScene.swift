//
//  MenuScene.swift
//  swift ninja
//
//  Created by juran_k on 1/23/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    //let playButtonTex = SKTexture(imageNamed: "play")
    var playButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        playButton = SKLabelNode(fontNamed: "Chalkduster")
        playButton.fontSize = 68
        playButton.text = "Play"
        playButton.color = UIColor.white
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(playButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                
                if let view = view {
                    playButton.color = UIColor.lightGray
                    let transition:SKTransition = SKTransition.reveal(with: .down, duration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
