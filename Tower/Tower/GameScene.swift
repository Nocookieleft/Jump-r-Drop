//
//  GameScene.swift
//  Tower
//
//  Created by Evil Cookie on 01/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//
// The main scene of the game that loads in all the sprites and holds the game logic. 
// The scene will load in an avatar of the PLayer class, an invisible platform generator that renders the platforms the avatar can rest on,
// a moving background, some invisible tresholds, a message before the game starts and a pause button that opens and closes a pause menu.
// The player needs to climb the platforms to the top of the level and grab a carrot that is also rendered by the platform generator to win the game. 
// Should the player fall down when there is no platform beneath him, the player falls offscreen and loses the game. 
// In the pause menu, one can always restart the game or resume its activities in the game.


import Foundation
import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // nodes with sprites
    var platformgenerator : PlatformGenerator!
    var player : Player? = nil
    
    // buttons, labels and menu nodes
    var startLabel = SKLabelNode(fontNamed: "Noteworthy")
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var menuNode = SKShapeNode()
    
    // tresholds
    let lowerTreshold = SKSpriteNode()
    let upperTreshold = SKSpriteNode()

    // game cycle variables
    var isStarted = false
    var level : MovingLevel!
    
    
    // setup the scene by loading in the (sprite-)nodes
    override func didMoveToView(view: SKView) {
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
        
        // show a nice label at the start of the game
        spawnStartLabel()
        
        // load in pause button
        spawnPauseButton()
        
        // load the upper and lower tresholds
        loadTresholds()
        
        // load the boundary of the screen
        loadRockBottom()
        
        // add physicsWorld
        physicsWorld.contactDelegate = self
        
    }
    
    
    // in case contact with two physics bodies are colliding with each other
    func didBeginContact(contact: SKPhysicsContact) {
        if isStarted 
        {
            let collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)
            
            // in case sprites of the player and platformcategory make contact, reset position of player
            if (collision == (playerCategory | platformCategory) )
            {
                let position = contact.bodyB.area
                player!.resetBaseLine(position)
            
            // in case the player hits the upper treshold, let the platforms move down
            }else if (collision == (playerCategory | upperTresholdCategory))
            {
                platformgenerator.startMovingAll()
            
            // in case the player hits the lower treshold, stop the movement of the platforms
            }else if (collision == (playerCategory | lowerTresholdCategory))
            {
                platformgenerator.stopAll()
            
            // in case the platforms hit rockbottom, remove their sprite from their parent
            }else if (collision == (platformCategory | rockBottomCategory))
            {
                
                platformgenerator.platforms.removeLast()
                
            // in case the player hits rockbottom, let the game be over and the player has lost
            }else if (collision == (playerCategory | rockBottomCategory))
            {
                gameOver(false)
            }
            
            // in case the player hits the finishline the game is over as well, but the player wins
            else if (collision == (playerCategory | finishLineCategory))
            {
                gameOver(true)
            }
        }
    }
    
    
    
    // load an invisible barrier in the screen with physicsbody to check progress of player
    func loadTresholds(){
        upperTreshold.color = UIColor.clearColor()
        upperTreshold.size = CGSize(width: view!.frame.size.width * 2, height: kPlatformHeight)
        upperTreshold.position = CGPointMake(kMinX, view!.center.y)
        upperTreshold.zPosition = backgroundZposition
        
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
        lowerTreshold.zPosition = backgroundZposition
        
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
        player!.zPosition = playerZposition
        addChild(player!)
        
    }
    
    
    // show a message on the screen before game starts
    func spawnStartLabel(){
        startLabel.text = "Tap to Start Game"
        startLabel.fontColor = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1)
        startLabel.zPosition = labelZpostion
        startLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height * 0.7)
        addChild(startLabel)

    }
    
    // show a pause button in the right upper corner of the screen
    func spawnPauseButton(){
        pauseButton.size = CGSizeMake(kPlatformHeight * 1.6, kPlatformHeight * 1.6)
        pauseButton.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        pauseButton.zPosition = labelZpostion
        pauseButton.name = "pauseButton"
        addChild(pauseButton)
    }
    

    // change properties to let game start
    func start(){
        startLabel.removeFromParent()
        player!.start()
        level.start()
        isStarted = true 
    }
    
    // stop all processes and move to the game over scene
    func gameOver(won: Bool){
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
        menuNode.zPosition = menuZposition
        menuNode.fillColor = kColorDarkBlue
        addChild(menuNode)
        
        // make a button shape to indicate that the user can click here and restart the game
        let buttonNode1 = SKShapeNode(rectOfSize: CGSizeMake(menuNode.frame.width * 0.9, 60))
        buttonNode1.position = convertPoint(CGPoint(x: size.width/2, y: size.width/1.8), toNode: menuNode)
        buttonNode1.name = "RestartButton"
        buttonNode1.fillColor = kColorDarkBlue
        buttonNode1.zPosition = buttonZposition
        menuNode.addChild(buttonNode1)
        
        // make a second button shape underneath for the resume button
        let buttonNode2 = SKShapeNode(rectOfSize: CGSizeMake(menuNode.frame.width * 0.9, 60))
        buttonNode2.position = convertPoint(CGPoint(x: size.width/2, y: size.height/2.4), toNode: menuNode)
        buttonNode2.name = "ResumeButton"
        buttonNode2.fillColor = kColorDarkBlue
        buttonNode2.zPosition = buttonZposition
        menuNode.addChild(buttonNode2)
        
        // label the restart button with dark blue font and text
        let restartGameNode = SKLabelNode(text: "Restart")
        restartGameNode.name = "restartGameNode"
        restartGameNode.fontName = "muli"
        restartGameNode.fontSize = 20
        restartGameNode.fontColor = kColorDeepDarkBlue
        restartGameNode.position = convertPoint(CGPoint(x: size.width/2, y: size.width/1.8), toNode: buttonNode1)
        restartGameNode.zPosition = labelZpostion
        buttonNode1.addChild(restartGameNode)
        
        // label the resume button with a dark blue font and text
        let resumeGameNode = SKLabelNode(text: "Resume ")
        resumeGameNode.name = "resumeGameNode"
        resumeGameNode.fontName = "muli"
        resumeGameNode.fontSize = 20
        resumeGameNode.fontColor = kColorDeepDarkBlue
        resumeGameNode.position = convertPoint(CGPoint(x: size.width/2, y: size.height/2.4), toNode: buttonNode2)
        resumeGameNode.zPosition = labelZpostion
        buttonNode2.addChild(resumeGameNode)
        
        // set a message on the screen telling the user that the game is paused
        let gameIsPausedMessage = SKLabelNode(text: "Game is Paused")
        gameIsPausedMessage.name = "pauseMessage"
        gameIsPausedMessage.fontName = "Noteworthy"
        gameIsPausedMessage.fontSize = 30
        gameIsPausedMessage.fontColor = kColorDeepDarkBlue
        gameIsPausedMessage.position = convertPoint(CGPoint(x: size.width/2, y: size.height * 0.6), toNode: menuNode)
        gameIsPausedMessage.zPosition = labelZpostion
        menuNode.addChild(gameIsPausedMessage)
        
        // pause the whole scene
        scene!.paused = true
    }
    
    // stop all actions and nodes and generate a new Gamescene
    func restartGame(){
        player!.isAlive = false
        platformgenerator.stopAll()
        level.stop()
        self.removeAllChildren()
        
        if let newScene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            
            let newView = self.view! as SKView
            newScene.size = CGSizeMake(view!.bounds.size.width, view!.bounds.size.height)
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
        if player!.position.y > (view!.center.y * 1.2)
        {
            platformgenerator.adjustSpeed("speedUp")
        }else if player!.position.y < frame.size.height * 0.4
        {
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
                // check if a node has been touched by checking the name of the node
                if nodeName == "pauseButton"
                {
                    if !scene!.paused 
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

                }else if nodeName == "platform" && !scene!.paused                 {
                    player!.jump()
                }
            
            // let the player jump when game is not on pause and if player touches point in the screen without a node
            }else if !scene!.paused
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
        if !scene!.paused
        {
            player!.update()
            setSpeed()
                
        }
    }
}

