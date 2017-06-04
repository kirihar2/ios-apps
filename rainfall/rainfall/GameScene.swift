//
//  GameScene.swift
//  rainfall
//
//  Created by juran_k on 5/30/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
    case load_screen
    case start
    case paused
    case ended
    case end_scene
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var scoreLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var colorLabel: SKLabelNode!
    var pauseIcon: SKSpriteNode!
    var gameState = GameState.load_screen

    var level: Int = 1  {
        didSet {
         levelLabel.text = "Level \(level)"
        }
    }//designed for 20 levels
    private var numColors = 2 //number of colors to cycle
    private var current_color: Int = 0 {
        didSet {
            colorLabel.text = "\(current_color)"
        }
    }
    
    var frame_width : CGFloat!
    var frame_height : CGFloat!
    private var gameScore: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(gameScore)"
        }
    }
    private var levelTimeLabel: SKLabelNode!
    private var levelTime: Int = 60  {
        didSet {
            levelTimeLabel.text = "\(levelTime)"
        }
    }//designed for 20 levels
    private var raindrops = [raindrop]()
    
    
    private var startTime = TimeInterval()
    private var timer = Timer()
    var readyForDrop = false
    private var rain_width = 100
    private var rain_height = 200
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        frame_width = scene!.frame.size.width
        frame_height = scene!.frame.size.height
        startupWithLevel()
        createScore()
        createLevelLabel()
        createLevelTimeLabel()
        createColorLabel()
        createPauseIcon()
        runTimer()
        //print (scene!.frame)
        let box = CGRect(x: 0, y:  CGFloat(-1 * rain_height), width: scene!.frame.size.width, height: scene!.frame.size.height + 2 * CGFloat(rain_height))
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: box)
        physicsWorld.contactDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.startupWithLevel()
        }
        gameState = .start
        
    }
    func createPauseIcon() {
        pauseIcon = SKSpriteNode()
        pauseIcon.size = CGSize(width:200, height:200 )
        pauseIcon.position = CGPoint(x: frame_width/2, y: frame_height/2)
        pauseIcon.alpha = 0
        pauseIcon.name = "pauseIcon"
        pauseIcon.texture = SKTexture(imageNamed: "pause")
        pauseIcon.zPosition = 100
        addChild(pauseIcon)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pauseGame))
        tap.numberOfTapsRequired = 2
        view!.addGestureRecognizer(tap)
    }
    func createColorLabel() {
        colorLabel = SKLabelNode(fontNamed: "Chalkduster")
        colorLabel.text = "0"
        colorLabel.horizontalAlignmentMode = .right
        
        colorLabel.fontSize = 30
        colorLabel.zPosition = 100
        addChild(colorLabel)
        colorLabel.position = CGPoint(x: frame_width - 10, y: frame_height - colorLabel.fontSize)
    }
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: 8, y: 8)
        
    }
    func createLevelLabel() {
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level 1"
        levelLabel.horizontalAlignmentMode = .left
        
        levelLabel.fontSize = 30
        levelLabel.zPosition = 100
        addChild(levelLabel)
        
        levelLabel.position = CGPoint(x: 5, y: frame_height-levelLabel.fontSize)
    }
    func createLevelTimeLabel() {
        levelTimeLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelTimeLabel.text = String(levelTime)
        levelTimeLabel.horizontalAlignmentMode = .center
        levelTimeLabel.fontSize = 48
        levelTimeLabel.zPosition = 100
        addChild(levelTimeLabel)
        
        levelTimeLabel.position = CGPoint(x: frame_width/2, y: frame_height - levelTimeLabel.fontSize)
        
    }
    func startupWithLevel() {
        
        
//        addRaindrop()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.addRaindrop()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.addRaindrop()
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
//            self.addRaindrop()
//        }
        readyForDrop = true
    }
    
    func addRaindrop() {
        if gameState != .start {
            return
        }
        let raindrop_created = raindrop()
        let randColor = RandomInt(min: 0,max: numColors )
        let randomX = RandomInt(min: 1, max: Int(frame_width/CGFloat(raindrop_created.width)-1) )
//        print(randomX,frame_height,frame_width)
        raindrop_created.configure(position: CGPoint(x:  frame_width - CGFloat(randomX*raindrop_created.width), y: frame_height - CGFloat(raindrop_created.height)),velocity: 100,color: randColor)
//        raindrop_created.color = randColor
        raindrops.append(raindrop_created)
        addChild(raindrop_created)
    }
    func loadNextLevel() {
        level += 1
        startupWithLevel()
    }
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    func colorSwitch() {
        current_color += 1
        if current_color > numColors {
            current_color = 0
            
        }
        for i in raindrops {
            i.color += 1
            if i.color > numColors {
                i.color = 0
            }
            i.update()
        }
//        print(raindrops.count)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return }
        
        let location = touch.location(in: self)
        
        
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "raindrop" && gameState == .start {
                let tapped_raindrop = node.parent! as! raindrop
                print(current_color,tapped_raindrop.color)
                if current_color == tapped_raindrop.color {
                    gameScore += 1
                    let ind = raindrops.index(of: tapped_raindrop)
                    raindrops.remove(at: ind!)
                    tapped_raindrop.removeFromParent()
                    colorSwitch()
                }
                
                
                
            }
            else if node.name == "pauseIcon" && gameState == .paused {
                resumeGame()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "raindrop" && contact.bodyB.node?.name != "raindrop" && gameState == .start{
            if let raindropContact = contact.bodyA.node!.parent as? raindrop {
//                raindropContact.velocity = 0
//                print("hit")
                //raindropContact.changeVelocity(v: CGVector(dx: 0, dy: 0 ))
                
//                raindropContact.color += 1
//                raindropContact.velocity = 0
//                raindropContact.physicsBody?.isDynamic = false
//                
//                
//                raindropContact.update()
//                endGame()
                let ind = raindrops.index(of: raindropContact)
                raindrops.remove(at: ind!)
                
                raindropContact.removeFromParent()
            }
            
            
        }
        else if contact.bodyB.node?.name == "raindrop" && contact.bodyA.node?.name != "raindrop" && gameState == .start {
            if let raindropContact = contact.bodyB.node!.parent as? raindrop {
//                raindropContact.velocity = 0
//                print("hit")
//                raindropContact.changeVelocity(v: CGVector(dx: 0, dy: 0 ))
                
//                raindropContact.color += 1
//                raindropContact.velocity = 0
//                raindropContact.physicsBody?.isDynamic = false
//                raindropContact.update()
//                endGame()
                let ind = raindrops.index(of: raindropContact)
                raindrops.remove(at: ind!)
                raindropContact.removeFromParent()
            }
            
            
            
        }
        
    }
    
    func removeAllRaindrops() {
        for i in raindrops {
            i.removeFromParent()
        }
        raindrops = []
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    func updateTimer() {
        levelTime -= 1     //This will decrement(count down)the seconds.
        if levelTime == 0 {
            gameState = .end_scene
            endGame()
            print("Game Over")
            pauseTimer()
        }
    }
    func pauseTimer() {
        timer.invalidate()
    }
    func endGame() {
        gameState = .ended
        for i in raindrops {
            i.velocity = 0
            i.update()
        }
    }
    
    func pauseGame() {
        pauseIcon.alpha = 1
        gameState = .paused
        for i in raindrops {
            i.velocity = 0
            i.update()
        }
        DispatchQueue.main.suspend()
        
        pauseTimer()
    }
    func resumeGame() {
        pauseIcon.alpha = 0
        gameState = .start
        runTimer()
        for i in raindrops {
            i.velocity = 100
            i.update()
        }
        DispatchQueue.main.resume()
    }
    func RandomInt(min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if levelTime > 0 && gameState == .start {//add game state here
            if readyForDrop {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
                    self.startupWithLevel()
                }
                readyForDrop = false
            }
        }
        
    }
}
