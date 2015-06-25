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
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var menuNode = SKShapeNode()

    
    // game cycle variables
    var isOver = false
    var isOnPause = false
    var isStarted = false
    var level : MovingLevel!
    var score = 0
    
    

    override func didMoveToView(view: SKView) {
        /* Setup scene properties */
        backgroundColor = kColorLightBlue
      
        // add ground of first level and invisible platformgenerator
        platformgenerator = PlatformGenerator(color: UIColor.clearColor(), size: view.frame.size)
        platformgenerator.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(platformgenerator)
        
        // add ground and platforms to level
        platformgenerator.addGround(size.width)
        platformgenerator.populate(frame.size.width, num: 10)
        
        // spawn player and setup properties
        spawnPlayer()
        
        level = MovingLevel(size: CGSizeMake(view.frame.width, view.frame.height))
        level.position = CGPoint(x: 0, y: 0)
        addChild(level)
        
        // show a label that keeps score
        spawnScoreLabel()
        
        // show a nice label at the start of the game
        spawnStartLabel()
        
        // load in pause button
        spawnPauseButton()
        
        // load the treshold in the middle of the screen
        loadTresholds()
        
        // load the boundary of the screen
        loadRockBottom()
        
        // add physicsWorld
        physicsWorld.contactDelegate = self
        
    }
    
    
    // in case contact with two physics bodies are colliding with each other, start moving the screen
    func didBeginContact(contact: SKPhysicsContact) {
        if isStarted 
        {
            let collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)

            if (collision == (playerCategory | platformCategory) )
            {
                let position = contact.bodyB.area
                player!.resetBaseLine(position)
                
            }else if (collision == (playerCategory | upperTresholdCategory))
            {
                platformgenerator.startGen2()
                platformgenerator.startMovingAll()
                
            }else if (collision == (playerCategory | lowerTresholdCategory))
            {
                platformgenerator.stopAll()
                
            }else if (collision == (platformCategory | rockBottomCategory))
            {
                
                platformgenerator.platforms.removeLast()
                
            }else if (collision == (playerCategory | rockBottomCategory))
            {
                gameOver(false)
            }
            else if (collision == (playerCategory | finishLineCategory))
            {
                gameOver(true)
            }
           
        }
        
    }
    
    
    // show when contact is over
    func didEndContact(contact: SKPhysicsContact) {
      //  println("over")

    }
    
    // load an invisible barrier in the screen with physicsbody to check progress of player
    func loadTresholds(){
        upperTreshold.color = UIColor.clearColor()
        upperTreshold.size = CGSize(width: view!.frame.size.width * 2, height: 10)
        upperTreshold.position = CGPointMake(kMinX, view!.center.y)
        upperTreshold.zPosition = 2
        
        // set physics forces to flag contact with player its avatar, set collision only to itself
        upperTreshold.physicsBody = SKPhysicsBody(rectangleOfSize: upperTreshold.size)
        upperTreshold.physicsBody?.dynamic = false
        upperTreshold.physicsBody?.categoryBitMask = upperTresholdCategory
        upperTreshold.physicsBody?.contactTestBitMask = playerCategory
        upperTreshold.physicsBody?.collisionBitMask = upperTresholdCategory
        addChild(upperTreshold)
        
        // load invisible barrier a little beneath the lower half of the screen
        lowerTreshold.color = UIColor.clearColor()
        lowerTreshold.size = upperTreshold.size
        lowerTreshold.position = CGPointMake(kMinX, view!.center.y * 0.3)
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
    func loadRockBottom(){
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0.0, y: -2, width: size.width * 2, height: frame.size.height * 3))
        physicsBody?.categoryBitMask = rockBottomCategory
        physicsBody?.contactTestBitMask = playerCategory | platformCategory
        physicsBody?.collisionBitMask = playerCategory
        
    }
    
    
    // spawn an avatar in the middle of the screen
    func spawnPlayer(){
        player = Player(imageNamed: "bunny")
        player!.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        
        
        // determine the baseline of the player avatar and position the level)
        player!.baseLine = kPlatformHeight + (player!.size.height / 2 )
        player!.minX = player!.size.width
        player!.maxX = self.frame.size.width - player!.size.width
        player!.zPosition = 4
        addChild(player!)
        
    }
    
    // show the score label at the top left of the screen 
    func spawnScoreLabel(){
        scoreText.text = "Score: " + String(score)
        scoreText.fontSize = 20
        scoreText.fontColor = UIColor.blackColor()
        scoreText.position = CGPoint(x: size.width / 6, y: size.height * 0.9)
        scoreText.zPosition = 5
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
    
    // show a pause button in the right upper corner of the screen
    func spawnPauseButton(){
        pauseButton.size = CGSizeMake(kPlatformHeight * 1.6, kPlatformHeight * 1.6)
        pauseButton.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        pauseButton.zPosition = 4
        pauseButton.name = "pauseButton"
        addChild(pauseButton)
    }
    

    // change properties to let game start
    func start(){
        startLabel.removeFromParent()
        player!.start()
        level.start()
        isStarted = true 
        //platformgenerator.startGen2()
    }
    
    
    
    // stop all processes and move to the game over scene
    func gameOver(won: Bool){
        isOver = true
        player!.isAlive = false
        platformgenerator.stopAll()
        level.stop()
        self.removeAllChildren()
        
        presentGameOverScene(won)

    }
   
    // pause the game and show a menu for the user to restart game or resume
    func pauseGame(){
        menuNode = SKShapeNode(rectOfSize: CGSizeMake(view!.frame.width/2, view!.frame.height*0.5))
        menuNode.position = view!.center
        menuNode.zPosition = 5
        menuNode.fillColor = kColorDarkBlue
        addChild(menuNode)
        
        // make a button shape to indicate that the user can click here and restart the game
        let buttonNode1 = SKShapeNode(rectOfSize: CGSizeMake(menuNode.frame.width * 0.9, 60))
        buttonNode1.position = convertPoint(CGPoint(x: size.width/2, y: size.width/1.8), toNode: menuNode)
        buttonNode1.name = "RestartButton"
        buttonNode1.fillColor = kColorDarkBlue
        buttonNode1.zPosition = 6
        menuNode.addChild(buttonNode1)
        
        // make a second button shape underneath for the resume button
        let buttonNode2 = SKShapeNode(rectOfSize: CGSizeMake(menuNode.frame.width * 0.9, 60))
        buttonNode2.position = convertPoint(CGPoint(x: size.width/2, y: size.height/2.4), toNode: menuNode)
        buttonNode2.name = "ResumeButton"
        buttonNode2.fillColor = kColorDarkBlue
        buttonNode2.zPosition = 6
        menuNode.addChild(buttonNode2)
        
        // label the restart button with dark blue font and text
        let restartGameNode = SKLabelNode(text: "Restart")
        restartGameNode.name = "restartGameNode"
        restartGameNode.fontName = "muli"
        restartGameNode.fontSize = 20
        restartGameNode.fontColor = kColorDeepDarkBlue
        restartGameNode.position = convertPoint(CGPoint(x: size.width/2, y: size.width/1.8), toNode: buttonNode1)
        restartGameNode.zPosition = 7
        buttonNode1.addChild(restartGameNode)
        
        // label the resume button with a dark blue font and text
        let resumeGameNode = SKLabelNode(text: "Resume ")
        resumeGameNode.name = "resumeGameNode"
        resumeGameNode.fontName = "muli"
        resumeGameNode.fontSize = 20
        resumeGameNode.fontColor = kColorDeepDarkBlue
        resumeGameNode.position = convertPoint(CGPoint(x: size.width/2, y: size.height/2.4), toNode: buttonNode2)
        resumeGameNode.zPosition = 7
        buttonNode2.addChild(resumeGameNode)
        
        // set a message on the screen telling the user that the game is paused
        let gameIsPausedMessage = SKLabelNode(text: "Game is Paused")
        gameIsPausedMessage.name = "pauseMessage"
        gameIsPausedMessage.fontName = "Noteworthy"
        gameIsPausedMessage.fontSize = 30
        gameIsPausedMessage.fontColor = kColorDeepDarkBlue
        gameIsPausedMessage.position = convertPoint(CGPoint(x: size.width/2, y: size.height * 0.6), toNode: menuNode)
        gameIsPausedMessage.zPosition = 7
        menuNode.addChild(gameIsPausedMessage)
        
        scene!.paused = true
        isOnPause = true
    }
    
    // stop all actions and nodes and generate a new Gamescene
    func restartGame(){
        isOver = true
        player!.isAlive = false
        platformgenerator.stopAll()
        level.stop()
        self.removeAllChildren()
        
        if let newScene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            
            let newView = self.view! as SKView
            
            newScene.size = CGSizeMake(view!.bounds.size.width, view!.bounds.size.height)
            /* Set the scale mode to scale to fit the window */
            newScene.scaleMode = .AspectFill
            
            newView.presentScene(newScene)
        }else
        {
            println("Failed to Restart Game")
        }

        
    }
    
    
    // resume game by removing the menu and resuming all paused actions
    func resumeGame(){
        menuNode.removeFromParent()
        scene!.paused = false
        isOnPause = false
    }
    
    
    // present the game over view with the same width and height as the gamescene
    func presentGameOverScene(won: Bool){
        if let GOScene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
            
            let GOView = self.view! as SKView
            
            GOScene.size = CGSizeMake(view!.bounds.size.width, view!.bounds.size.height)
            GOScene.scaleMode = .AspectFill
            if won
            {
                GOScene.hasWon = true
            }else
            {
                GOScene.hasWon = false
            }
            
            GOView.presentScene(GOScene)
        }else
        {
            println("Failed to present Game Over screen ")
        }
    
    }
    
    // adjust speed of player according to the position on screen
    func setSpeed(){
        if player!.position.y > view!.center.y * 1.2
        {
            player!.addedGravity = 5.0
            platformgenerator.adjustSpeed("speedUp")
        }else if player!.position.y < frame.size.height * 0.4
        {
            player!.addedGravity = 0
            platformgenerator.adjustSpeed("slowDown")
        }
    }
    
    
    // called when a player touches the screen
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // first check if the game has started, else start processes
        if (!isStarted)
        {
            start()
        }
        // analyse where the player touches in the coordinate system of the scene
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            if let nodeName = touchedNode.name
            {
                // check if a node has been touched by checking nodes name
                if nodeName == "pauseButton"
                {
                    if !isOnPause
                    {
                        pauseGame()
                    }else
                    {
                        resumeGame()
                    }
                }
                else if nodeName == "resumeGameNode" || nodeName == "ResumeButton"
                {
                        resumeGame()
                }
                else if nodeName == "restartGameNode" || nodeName == "RestartButton"
                {
                        restartGame()

                }else if nodeName == "platform" && !isOnPause
                {
                    player!.jump()
                }
            
            // let the player jump when game is not on pause and if player touches point in the screen without a node
            }else if !isOnPause
            {
                player!.jump()
            }

        }

    }
    
    
    // slow down player jump
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        player!.slowDownJump()
    }
    
    
    // update the player's status in the game while the avatar is still alive
    override func update(currentTime: CFTimeInterval) {
        if !isOnPause
        {
            player!.update()
            setSpeed()
            scoreText.text = "Score: \(score) "
    //      level.update(currentTime)
            
                
        }
    }
}

