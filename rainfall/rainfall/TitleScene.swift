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
    var backgroundRain : SKEmitterNode!
    var frame_width : CGFloat!
    var frame_height : CGFloat!
    let density_factor = 0.5
    private var gameTitle: SKLabelNode!
    private var startGameButton: SKLabelNode!
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later

        frame_width = scene!.frame.size.width
        frame_height = scene!.frame.size.height
        let center = CGPoint(x: frame_width/2, y: frame_height/2)

        backgroundRain = SKEmitterNode(fileNamed: "TitleRainBackground")
        backgroundRain.position =  CGPoint(x: frame_width/2, y: frame_height)
        backgroundRain.particlePositionRange = CGVector(dx: frame_width * 1.5, dy: frame_height * 0.05)
        backgroundRain.particleBirthRate = frame_width * CGFloat(density_factor)
        addChild(backgroundRain)
        
        gameTitle = SKLabelNode(fontNamed: "Chalkduster")
        gameTitle.fontSize = 50
        gameTitle.text = "Rainfall"
        gameTitle.name = "gameTitle"
        gameTitle.position = CGPoint(x: frame_width/2, y: frame_height - gameTitle.fontSize)
        gameTitle.zPosition = 1
        addChild(gameTitle)
        
        startGameButton = SKLabelNode(fontNamed: "Chalkduster")
        startGameButton.text = "Start Game"
        startGameButton.position = center
        startGameButton.fontSize = 40
        startGameButton.zPosition = 1
        startGameButton.name = "startGameButton"
        addChild(startGameButton)
        
        
    }
    private func startGame() {
        let gameScene = GameScene(size: scene!.frame.size)
        let transition = SKTransition.fade(withDuration: 0.5)
        view!.presentScene(gameScene, transition: transition)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "startGameButton"{
                startGame()
            }
        }
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
