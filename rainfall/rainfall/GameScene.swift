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
    case raining
    case finished_level
    case resetting
    case ended
    case end_scene
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var scoreLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var colorLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var levelTimeConst = 60
    private var livesRemaining: Int = 3  {
        didSet {
            livesLabel.text = "Level \(livesRemaining)"
        }
    }
    var backgroundFade: SKSpriteNode!
    var gameOverPopOver: SKSpriteNode!
    private var restartButton: SKSpriteNode!
    var returnToTitleButton: SKSpriteNode!
    
    var pauseIcon: SKSpriteNode!
    var gameState = GameState.load_screen

    var level: Int = 1  {
        didSet {
         levelLabel.text = "Level \(level)"
        }
    }//designed for 20 levels
    private var numColors = 3 //number of colors to cycle
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
    private var levelTime: Int = 5  {
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
    private var needed_score = 10
    private var last_removed_raindrop: raindrop!
    var center: CGPoint!
    let origin = CGPoint(x: 0 , y: 0)
    var raindropSwipeEmitter : SKEmitterNode!
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        frame_width = scene!.frame.size.width
        frame_height = scene!.frame.size.height
        center = CGPoint(x: frame_width/2, y: frame_height/2)
        
        startupWithLevel()
        createScore()
        createLevelLabel()
        createLevelTimeLabel()
        createColorLabel()
        createPauseIcon()
        createGameOverPrompt()
        runTimer()
        
        let box = CGRect(x: 0, y:  CGFloat(-1 * rain_height), width: scene!.frame.size.width, height: scene!.frame.size.height + 2 * CGFloat(rain_height))
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: box)
        physicsWorld.contactDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.startupWithLevel()
        }
        gameState = .start
        
        
    }
    func createGameOverPrompt() {
        backgroundFade = SKSpriteNode(color: .black, size: CGSize(width:frame_width, height: frame_height))
        backgroundFade.position = CGPoint(x: frame_width/2, y: frame_height/2)
        backgroundFade.alpha = 0
        backgroundFade.zPosition = 101
        addChild(backgroundFade)
        
        gameOverPopOver = SKSpriteNode(color: .white, size: CGSize(width: frame_width * 3/4 , height: frame_height/4) )
        gameOverPopOver.position = center
        gameOverPopOver.alpha = 0
        gameOverPopOver.zPosition = 102
        
        restartButton = SKSpriteNode(color: .black, size: CGSize(width: gameOverPopOver.size.width/2, height: gameOverPopOver.size.height/6))
        restartButton.name = "restartButton"
        let restartButtonLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartButtonLabel.text = "Restart"
        restartButtonLabel.fontSize = 30
        restartButton.addChild(restartButtonLabel)
        let fontPosition = CGPoint(x: 0, y: -1 * restartButtonLabel.fontSize/2)
        restartButtonLabel.position = fontPosition
        returnToTitleButton = SKSpriteNode(color: .black, size: CGSize(width: gameOverPopOver.size.width/2, height: gameOverPopOver.size.height/6))
        returnToTitleButton.name = "returnToTitleButton"
        
        let returnToTitleButtonLabel = SKLabelNode(fontNamed: "Chalkduster")
        returnToTitleButtonLabel.text = "Return to Title"
        returnToTitleButtonLabel.fontSize = 30
        
        returnToTitleButton.addChild(returnToTitleButtonLabel)
        returnToTitleButtonLabel.position = fontPosition
        
        let gameOverPromptLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverPromptLabel.fontSize = 50
        gameOverPromptLabel.text = "Game Over"
        gameOverPromptLabel.fontColor = .black
        
        gameOverPopOver.addChild(gameOverPromptLabel)
        gameOverPopOver.addChild(returnToTitleButton)
        gameOverPopOver.addChild(restartButton)
        
        restartButton.position = CGPoint(x: 0 , y: -1 * gameOverPopOver.size.height/2 + restartButton.size.height + returnToTitleButton.size.height + 10 )
        returnToTitleButton.position = CGPoint(x: 0 , y: -1 * gameOverPopOver.size.height/2 + returnToTitleButton.size.height)
        gameOverPromptLabel.position = CGPoint(x: 0, y: gameOverPopOver.size.height/2 - gameOverPromptLabel.fontSize - 5)
        
        addChild(gameOverPopOver)
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
        levelTime = levelTimeConst
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
        let randColor = RandomInt(min: 1,max: numColors )
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
        current_color = (current_color + 1) % numColors
        
        for i in raindrops {
            i.color = (i.color + 1) % numColors
            i.update()
        }
//        print(raindrops.count)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return }
        
        let location = touch.location(in: self)
        last_removed_raindrop = nil
        
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
//                    colorSwitch()
                }
            }
            
            else if node.name == "pauseIcon" && gameState == .paused {
                resumeGame()
            }
            else if node.name == "restartButton" && gameState == .ended && readyForDrop {
                print("restarting game")
                resetGame()
            }
            else if node.name == "returnToTitleButton" && gameState == .ended && readyForDrop {
                
            }
            
        }
        if gameState == .start && raindropSwipeEmitter != nil{
            addRainEmitter()
            raindropSwipeEmitter.position = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return }
        
        let location = touch.location(in: self)
        
        
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "raindrop" && gameState == .start {
                let tapped_raindrop = node.parent! as! raindrop
                print(current_color,tapped_raindrop.color)
                if current_color == tapped_raindrop.color {
                    last_removed_raindrop = tapped_raindrop
                    gameScore += 1
                    let ind = raindrops.index(of: tapped_raindrop)
                    raindrops.remove(at: ind!)
                    tapped_raindrop.removeFromParent()
//                    colorSwitch()
                }
                
            }
            
            
        }
        if gameState == .start && raindropSwipeEmitter != nil{
            raindropSwipeEmitter.position = location
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if last_removed_raindrop != nil {
            colorSwitch()
            
        }
        if raindropSwipeEmitter != nil {
            endRainEmitter()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
           
        }
        if raindropSwipeEmitter != nil {
            endRainEmitter()
        }

    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "raindrop" && contact.bodyB.node?.name != "raindrop" && gameState == .start{
            if let raindropContact = contact.bodyA.node!.parent as? raindrop {
                let ind = raindrops.index(of: raindropContact)
                raindrops.remove(at: ind!)
                
                raindropContact.removeFromParent()
            }
            
            
        }
        else if contact.bodyB.node?.name == "raindrop" && contact.bodyA.node?.name != "raindrop" && gameState == .start {
            if let raindropContact = contact.bodyB.node!.parent as? raindrop {
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
            gameState = .finished_level
            if gameScore < needed_score {
                gameState = .end_scene
                endGame()
                print("Game Over")
                pauseTimer()
            }
        }
    }
    func addRainEmitter() {
        raindropSwipeEmitter = SKEmitterNode(fileNamed: "MyParticle")
        raindropSwipeEmitter.zPosition = 100
        addChild(raindropSwipeEmitter)
        
    }
    func endRainEmitter() {
        if raindropSwipeEmitter != nil {
            raindropSwipeEmitter.removeFromParent()
        }
    }
    func pauseTimer() {
        timer.invalidate()
    }
    func endGame() {
        gameState = .ended
        let fadeIn = SKAction.fadeAlpha(to: 0.75, duration: 0.2)
        backgroundFade.run(fadeIn)
    }
    
    func pauseGame() {
        pauseIcon.alpha = 1
        gameState = .paused
        for i in raindrops {
            i.pauseRaindrop()
        }
        DispatchQueue.main.suspend()
        
        pauseTimer()
    }
    func resumeGame() {
        pauseIcon.alpha = 0
        gameState = .start
        runTimer()
        for i in raindrops {
            i.resumeRaindrop()
        }
        DispatchQueue.main.resume()
    }
    func RandomInt(min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    func resetGame() {
        removeAllRaindrops()
        let fadeOut = SKAction.fadeAlpha(to: 0 , duration: 0.2)
        backgroundFade.run(fadeOut)
        
        let promptFadeOut = SKAction.fadeAlpha(to: 0, duration: 0.2)
        gameOverPopOver.run(promptFadeOut)
        gameState = .resetting
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
        else if levelTime == 0 && gameState == .finished_level {
            
        }
        else if levelTime == 0 && gameState == .ended && readyForDrop {
            
            //game over prompt here so when user presses the button there is nothing in the queue
            let promptFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.2)
            gameOverPopOver.run(promptFadeIn)
        }
        else if levelTime == 0 && gameState == .resetting && raindrops.count == 0 {
            //check if all raindrops finished animation
            gameState = .start
            levelTime = levelTimeConst
            runTimer()
            if readyForDrop {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
                    self.startupWithLevel()
                }
                readyForDrop = false
            }
        }
    }
}
