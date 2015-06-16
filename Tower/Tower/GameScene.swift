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
    var background : SKNode!
    var platformgenerator : PlatformGenerator!
    var player : Player? = nil
    let scoreText = SKLabelNode(fontNamed: "Muli")
    var startLabel = SKLabelNode(fontNamed: "Noteworthy")
    let upperTreshold = SKSpriteNode()
    let lowerTreshold = SKSpriteNode()
    
    
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
        
        // add ground and platforms to level
        platformgenerator.addGround(frame.size.width)
     //   platformgenerator.populate(frame.size.width, num: 8)
                
        // spawn player and setup properties
        spawnPlayer()
        
        level = MovingLevel(size: CGSizeMake(view.frame.width, view.frame.height))
        level.position = CGPoint(x: 0, y: 0)
        addChild(level)
        
        // show a label that keeps score
        spawnScoreLabel()
        
        // show a nice label at the start of the game
        spawnStartLabel()
        
        // load the treshold in the middle of the screen
        loadTresholds()
        
        // load the boundary of the screen
        loadBoundary()
        
        // add physicsWorld
        physicsWorld.contactDelegate = self
        
    }
    
    
    // in case contact with two physics bodies are colliding with each other, start moving the screen
    func didBeginContact(contact: SKPhysicsContact) {
        if isStarted 
        {
            let collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)

            if (collision == (playerCategory | platformCategory))
            {
                let position = contact.bodyB.area
                player!.resetBaseLine(position)
                player!.isGrounded = true
                
            }else if (collision == (playerCategory | upperTresholdCategory))
            {
                platformgenerator.startMovingAll()
                
            }else if (collision == (playerCategory | lowerTresholdCategory))
            {
                platformgenerator.stopAll()
                
            }else if (collision == (playerCategory | bottomCategory))
            {
                gameOver()
            }
           
        }
        
    }
    
    
    // show when contact is over
    func didEndContact(contact: SKPhysicsContact) {
      //  println("over")

    }
    
    // load an invisible barrier in the screen with physicsbody to check progress of player
    func loadTresholds(){
        upperTreshold.color = UIColor.redColor()
        upperTreshold.size = CGSize(width: view!.frame.size.width * 2, height: 10)
        upperTreshold.position = CGPointMake(kMinX, view!.center.y * 1.2)
        upperTreshold.zPosition = 2
        
        // set physics forces to flag contact with player its avatar, set collision only to itself
        upperTreshold.physicsBody = SKPhysicsBody(rectangleOfSize: upperTreshold.size)
        upperTreshold.physicsBody?.dynamic = false
        upperTreshold.physicsBody?.categoryBitMask = upperTresholdCategory
        upperTreshold.physicsBody?.contactTestBitMask = playerCategory
        upperTreshold.physicsBody?.collisionBitMask = upperTresholdCategory
        addChild(upperTreshold)
        
        lowerTreshold.color = UIColor.yellowColor()
        lowerTreshold.size = upperTreshold.size
        lowerTreshold.position = CGPointMake(kMinX, view!.center.y * 0.4)
        //        treshold.position = convertPoint(CGPoint(x: kMinX, y: view!.center.y * 0.8),  toNode: level!)
        lowerTreshold.zPosition = 2
        
        // set physics forces to flag contact with player its avatar, set collision only to itself
        lowerTreshold.physicsBody = SKPhysicsBody(rectangleOfSize: lowerTreshold.size)
        lowerTreshold.physicsBody?.dynamic = false
        lowerTreshold.physicsBody?.categoryBitMask = lowerTresholdCategory
        lowerTreshold.physicsBody?.contactTestBitMask = playerCategory
        lowerTreshold.physicsBody?.collisionBitMask = lowerTresholdCategory
        addChild(lowerTreshold)
        
    }
    
    
    // set the boundary of the screen to detect if the avatar falls
    func loadBoundary(){
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0.0, y: 0.0, width: size.width * 2, height: size.height))
        physicsBody?.categoryBitMask = bottomCategory
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.collisionBitMask = playerCategory
        
    }
    
    
    // spawn an avatar in the middle of the screen
    func spawnPlayer(){
        player = Player(imageNamed: "bulldozer")
        player!.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        
        
        // determine the baseline of the player avatar and position the level)
        player!.baseLine = kPlatformHeight + (player!.size.height / 2 )
        player!.minX = player!.size.width
        player!.maxX = self.frame.size.width - player!.size.width
        player!.zPosition = 3
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
    
    // show a message on the screen before game starts
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
        platformgenerator.startGen2()

    }
    
    
    
    // stop all processes and move to the game over scene
    func gameOver(){
        isOver = true
        player!.isAlive = false
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
        }else if (player!.isAlive)
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
        
        if (player!.isAlive == true)
        {
            player!.update()
            scoreText.text = "Score: \(score) "
            level.update(currentTime)
            
        }else
        {
            gameOver()

        }
        
    }
}

