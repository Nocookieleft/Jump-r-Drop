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
    var isOver = false
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
        level = MovingLevel(size: CGSizeMake(view.frame.width, view.frame.height))
        level.position = CGPoint(x: 0, y: 0)
        addChild(level)
        
        // position scorelabel with properties
        scoreText.text = "Score: " + String(score)
        scoreText.fontSize = 20
        scoreText.fontColor = UIColor.blackColor()
        scoreText.position = CGPoint(x: size.width / 6, y: size.height * 0.9)
        scoreText.zPosition = 3
        addChild(scoreText)

    }
    
    // reset the x and y postion of the player according to baseline and borders of frame
    func resetPlayer(){
        let minX = player!.size.width 
        let maxX = self.frame.size.width - player!.size.width
        
        if (player!.position.y < self.playerBaseline)
        {
            self.player!.position.y = self.playerBaseline
            player!.ground()
        }
        
        if (player!.position.x >= maxX)
        {
            player!.position.x = maxX
            player!.turn()
        }else if(player?.position.x <= minX)
        {
            player!.position.x = minX
            player!.turn()
        }
        
    }
    
    
    
    // change properties to let game start
    func start(){
        player!.start()
        isStarted = true
        
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
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // slow down player jump
        player!.slowDown()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        player!.update()
        resetPlayer()
        scoreText.text = "Score: " + String(score)
        level.update()
        
    }
}

