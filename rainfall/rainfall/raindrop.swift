//
//  raindrop.swift
//  rainfall
//
//  Created by juran_k on 6/2/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class raindrop: SKNode {
    
   
    var raindrop: SKSpriteNode!
    var isVisible = false
    var isHit = false
    var color = 0
    var width = 50
    
    var height = 100
    var texture : SKTexture!
    var velocity : CGFloat!
    func configure(position: CGPoint,velocity: CGFloat, color: Int){
        
        self.velocity = velocity
        
        raindrop = SKSpriteNode()
        raindrop.size = CGSize(width: width, height: height)
        //texture = SKTexture(imageNamed: "pusheen_open")
        
        let filestring = "water\(color+1)"
        texture = SKTexture(imageNamed: filestring)
            
        
        raindrop.texture = texture
        raindrop.position = position
        raindrop.name = "raindrop"
        
        applyPhys()
        
        addChild(raindrop)
        
        
    }
    func changeVelocity(v: CGVector) {
        raindrop?.physicsBody?.velocity = v
    }
    private func applyPhys() {
        raindrop.physicsBody = SKPhysicsBody(texture: texture, size: raindrop.size)
        raindrop.physicsBody?.isDynamic = true
        raindrop.physicsBody?.allowsRotation = false
        raindrop.physicsBody?.affectedByGravity = false
        raindrop.physicsBody!.contactTestBitMask = raindrop.physicsBody!.collisionBitMask
        raindrop.physicsBody?.collisionBitMask = 0 //this caused boundary to not work
        
        raindrop.physicsBody?.friction = 0
        raindrop.physicsBody?.linearDamping = 0
        raindrop.physicsBody?.restitution = 0.2 //change to 0 to fix small sounds
        raindrop.zPosition = 2
        raindrop.physicsBody?.velocity = CGVector(dx: 0, dy: -1 * velocity)
    }
    func update(){
        let filestring = "water\(color+1)"
        texture = SKTexture(imageNamed: filestring)
       
        raindrop.texture = texture
        
        applyPhys()
    }
}
