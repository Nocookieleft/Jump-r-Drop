//
//  GameScene.swift
//  Tower
//
//  Created by Evil Cookie on 01/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player : Player? = nil
    let gravity = CGFloat(0.6)
    let scoreText = SKLabelNode(fontNamed: "Muli")
    
    var isStarted = false
    var level : MovingLevel!
    var toggleMove = true
    var isOver = false
    var isGrounded = true
    var velocityY = CGFloat(0)
    var playerBaseline = CGFloat(0)
    var score = 0
    
    

    
    override func didMoveToView(view: SKView) {
        /* Setup scene properties */
        backgroundColor = UIColor(red: 204.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        // spawn player and setup properties
        
        player = Player(imageNamed: "Player")
        player!.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player!)
        let ground = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: size.width, height: 20))
        ground.position = CGPoint(x: size.width/2, y: size.height * 0.05)
        ground.zPosition = 2
        addChild(ground)
        
        // determine the baseline of the player avatar and position the level
        playerBaseline = ground.position.y + (ground.size.height / 2) + (player!.size.height / 2 )
        level = MovingLevel(size: CGSizeMake(size.width, view.frame.height))
        level.position = view.center
        addChild(level)
        
        // position scorelabel with properties
        scoreText.text = "Score: " + String(score)
        scoreText.fontSize = 20
        scoreText.fontColor = UIColor.blackColor()
        scoreText.position = CGPoint(x: size.width / 3, y: size.height * 0.9)
        scoreText.zPosition = 3
        addChild(scoreText)

    }
    
    
    // change properties to let game start
    func start(){
        isStarted = true
        
    }
    
    
    // action to move player
    func movePlayer(){
        if (player != nil)
        {
        let minX = player!.size.width / 2
        let maxX = self.frame.size.width - player!.size.width / 2
        
        // move avatar horizontally by its size and in 0.5 sec
        let actionMoveRight = SKAction.moveByX(player!.size.width, y: 0, duration: 1)
        let actionMoveLeft = SKAction.moveByX(-player!.size.width, y: 0, duration: 1)
        let actionWait = SKAction.waitForDuration(0.5)
        
        // let avatar move repeatedly
        if (toggleMove == true)
        {
        //    player.runAction(SKAction.sequence([actionMoveRight, actionWait]))
            player!.runAction(actionMoveRight)
        }else
        {
            player!.runAction(SKAction.sequence([actionMoveLeft, actionWait]))
            //player!.runAction(SKAction.repeatAction(actionMoveLeft, count: 1))
        }
        // change direction of avatar
       toggleMove = !toggleMove
        }
        

    }
    
    
    //make avatar jump by
    func jump(){
        if (player != nil)
        {
            
        self.velocityY += self.gravity
        player!.position.y -= velocityY
        
        // reset player position after jump
        if (player!.position.y < self.playerBaseline)
        {
            self.player!.position.y = self.playerBaseline
            velocityY = 0.0
            self.isGrounded = true
        }
        }
    }
    
//    func constrainPlayer(){
//       if (player != nil)
//       {
//            if (player!.position.x > frame.size.width)
//            {
//                toggleMove = !toggleMove
//            }else if (player!.position.x < (player!.size.width / 2))
//            {
//                toggleMove = !toggleMove
//            }
//        }
//    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a player touches screen */
        if (!isStarted)
        {
            start()
        }else
        {
            if (self.isGrounded == true)
            {
                velocityY = -18
                isGrounded = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // slow down player jump
        if (self.velocityY < -9.0)
        {
            self.velocityY = -9.0
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        movePlayer()
//        constrainPlayer()
        jump()
        scoreText.text = "Score: " + String(score)
//        if (level.shouldProgress() == true)
//        {
            level.progress()
            score++
//        }
    }
}

