//
//  GameScene.swift
//  Tower
//
//  Created by Evil Cookie on 01/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//
import Foundation
import SpriteKit



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // nodes with sprites
    var platformgenerator : PlatformGenerator!
    var player : Player? = nil
    let scoreText = SKLabelNode(fontNamed: "Muli")
    var startLabel = SKLabelNode(fontNamed: "Montserrat")
    let treshold = SKSpriteNode()
    
    
    // game cycle variables
    var isOver = false
    var isStarted = false
    var level : MovingLevel!
    var score = 0
    var test = 0
    
    
    
    

    override func didMoveToView(view: SKView) {
        /* Setup scene properties */
        backgroundColor = kColorLightBlue
      
        // add ground of first level
        platformgenerator = PlatformGenerator(color: UIColor.clearColor(), size: view.frame.size)
        platformgenerator.position = CGPoint(x: 0, y: 0)
        addChild(platformgenerator)
                
        // spawn player and setup properties
        spawnPlayer()
        
        level = MovingLevel(size: CGSizeMake(view.frame.width, view.frame.height))
        level.position = CGPoint(x: 0, y: frame.size.height/2)
        addChild(level)
        
        // show a label that keeps score
        spawnScoreLabel()
        
        // show a nice label at the start of the game
        spawnStartLabel()
        
        // add physicsWorld
        physicsWorld.contactDelegate = self
        
    }
    
    // in case delegate notices contact
    func didBeginContact(contact: SKPhysicsContact) {
        if isStarted 
        {
            let position = contact.bodyB.area
            println("contact")
            player!.resetBaseLine(position)
            player!.isGrounded = true
        }
        
    }
    
    
    func didEndContact(contact: SKPhysicsContact) {
        println("over")
    }
    
    
    func loadTreshold(){
        treshold.color = UIColor.redColor()
        treshold.size = CGSize(width: view!.frame.size.width, height: 10)
        treshold.position = CGPointMake(0, view!.center.y)
        addChild(treshold)
    }
    
    
    // spawn an avatar in the middle of the screen
    func spawnPlayer(){
        player = Player(imageNamed: "bulldozer")
        player!.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        platformgenerator.populate(frame.size.width, playerHeight: player!.size.height , num: 9)
        
        // determine the baseline of the player avatar and position the level)
        player!.baseLine = kPlatformHeight + (player!.size.height / 2 )
        player!.minX = player!.size.width
        player!.maxX = self.frame.size.width - player!.size.width
        player!.zPosition = 2
        addChild(player!)
        
    }
    
    // show the score label at the top left of the screen 
    func spawnScoreLabel(){
        scoreText.text = "Score: " + String(score)
        scoreText.fontSize = 20
        scoreText.fontColor = UIColor.blackColor()
        scoreText.position = CGPoint(x: size.width / 6, y: size.height * 0.9)
        scoreText.zPosition = 3
        addChild(scoreText)
        

    }
    
    func spawnStartLabel(){
        startLabel.text = "Tap to Start Game"
        startLabel.fontColor = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1)
        startLabel.zPosition = 10
        startLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height * 0.7)
        addChild(startLabel)

    }
    

    // change properties to let game start
    func start(){
        startLabel.removeFromParent()
        player!.start()
        level.start()
        isStarted = true
        platformgenerator.startGeneratingEvery(4)

    }
    
    
    
    // stop all processes and move to the game over scene
    func gameOver(){
        isOver = true
        player!.isIdle = true
        platformgenerator.stopAll()
        level.stop()
        self.removeAllChildren()
        
        presentGameOverScene()

    }
    
    
    
    // present the game over view
    func presentGameOverScene(){
        
        if let GOScene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
            
            let GOView = self.view! as SKView
            
            GOScene.size = CGSizeMake(view!.bounds.size.width, view!.bounds.size.height)
            /* Set the scale mode to scale to fit the window */
            GOScene.scaleMode = .AspectFill
            
            GOView.presentScene(GOScene)
        }else
        {
            println("shit didn't happen")
        }
    
    }
    
    
    // begin jump of player
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a player touches screen */
        if (!isStarted)
        {
            start()
        }else
        {
            player!.jump()
            test++
        }
    }
    
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // slow down player jump
        player!.slowDownJump()
    }
   
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        if (test <= 7)
        {
            player!.update()
            scoreText.text = "Score: " + String(score)
            level.update(currentTime)
        }else
        {
            gameOver()

        }
        
    }
}

