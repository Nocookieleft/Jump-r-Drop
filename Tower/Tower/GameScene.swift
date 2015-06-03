//
//  GameScene.swift
//  Tower
//
//  Created by Evil Cookie on 01/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed:"Player")
    let gravity = CGFloat(0.6)
    var isStarted = false
    var towerLvl: Int = 1
    var level : MovingLevel!
    var toggleMove = true
    var isOver = false
    var isGrounded = true
    var velocityY = CGFloat(0)
    var playerBaseline = CGFloat(0)
    
    

    
    override func didMoveToView(view: SKView) {
        /* Setup scene properties */
        backgroundColor = UIColor(red: 204.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        // spawn player and setup properties
        
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player)
        let ground = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: size.width, height: 20))
        ground.position = CGPoint(x: size.width/2, y: size.height * 0.05)
        ground.zPosition = 2
        self.playerBaseline = ground.position.y + (ground.size.height / 2) + (player.size.height / 2 )
        
        addChild(ground)
        level = MovingLevel(size: CGSizeMake(view.frame.width, view.frame.height))
        level.position = view.center
        
        addChild(level)

    }
    
    func start(){
        isStarted = true
        
    }
    
    func movePlayer(){
        let minX = player.size.width / 2
        let maxX = self.frame.size.width - player.size.width / 2
        
        // move avatar horizontally by its size and in 0.5 sec
        let actionMoveRight = SKAction.moveByX(player.size.width, y: 0, duration: 1)
        let actionMoveLeft = SKAction.moveByX(-player.size.width, y: 0, duration: 1)
        let actionWait = SKAction.waitForDuration(0.5)
        
        // let avatar move repeatedly
        if (toggleMove == true)
        {
        //    player.runAction(SKAction.sequence([actionMoveRight, actionWait]))
            player.runAction(actionMoveRight)
        }else
        {
            player.runAction(SKAction.sequence([actionMoveLeft, actionWait]))
            //player.runAction(SKAction.repeatAction(actionMoveLeft, count: 1))
        }
        // change direction of avatar
       toggleMove = !toggleMove
        

    }
    
    func jump(){
        self.velocityY += self.gravity
        player.position.y -= velocityY
        
        if (player.position.y < self.playerBaseline)
        {
            self.player.position.y = self.playerBaseline
            velocityY = 0.0
            self.isGrounded = true
        }
        
    }
    
    func constrainPlayer(){
        if (player.position.x > frame.size.width)
        {
            toggleMove = !toggleMove
        }else if (player.position.x < (player.size.width / 2))
        {
            toggleMove = !toggleMove
        }
    }
    
    
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
                self.isGrounded = false
            }
        }

    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (self.velocityY < -9.0)
        {
            self.velocityY = -9.0
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        movePlayer()
        constrainPlayer()
        jump()
        
    }
}
