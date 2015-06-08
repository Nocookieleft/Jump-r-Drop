//
//  Player.swift
//  Tower
//
//  Created by Evil Cookie on 01/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import SpriteKit

class Player : SKSpriteNode {
    
    var isGrounded = true
    var velocityY = CGFloat(0)
    var velocityX = CGFloat(0)
    var gravity = CGFloat(0.6)
    var isFacingRight = true
   
    
    init(imageNamed: String) {
       // render 
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: nil, size: imageTexture.size())
        
        // use physicsbody to simulate gravity and stuff on player avatar
        self.physicsBody = SKPhysicsBody(rectangleOfSize: imageTexture.size())
        self.physicsBody?.dynamic = false
        self.physicsBody?.mass = 1
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func turn(){
       
        var scale : CGFloat!
        
        if (isFacingRight == true)
        {
            scale = -1.0
            
        }else
        {
            scale = 1.0
        }
        let turn = SKAction.scaleXTo(scale, duration: 0.1)
        let translatepostion = SKAction.moveByX(scale * (size.width), y: 0, duration: 0.1)
        self.runAction(turn)
        isFacingRight != isFacingRight
        
    }
    
    // stop jumping of the player
    func ground(){
        
        velocityY = 0.0
        self.isGrounded = true
    }
    
    
    // begin avatar jump
    func jump(){
        
        if (self.isGrounded == true)
        {
            velocityY = -12
            isGrounded = false
        }

    }
    
    func move(){
        
        // move avatar horizontally by its size and
        let actionMoveRight = SKAction.moveByX(velocityX, y: 0, duration: 0.5)
        let actionMoveLeft = SKAction.moveByX(-velocityX, y: 0, duration: 0.5)
        let actionWait = SKAction.waitForDuration(0.5)
        
        // let avatar move repeatedly
        
        if (isFacingRight == true)
        {
         //   runAction(SKAction.sequence([actionMoveRight, actionWait]))
            self.runAction(actionMoveRight, completion: { () -> Void in
                self.runAction(actionWait)
            })
        }else
        {
           // runAction(SKAction.sequence([actionMoveLeft, actionWait]))
            self.runAction(actionMoveLeft, completion: { () -> Void in
                self.runAction(actionWait)
            })
            
        }

    }
    
    
    func start(){
        velocityX = self.size.width/5
    }
    
    
    // make avatar slow down jumping animation
    func slowDown(){
        if (self.velocityY < -6.0)
        {
            self.velocityY = -6.0
        }
    }
    
    
    // update position of the player
    func update(){
        
        self.velocityY += self.gravity
        self.position.y -= velocityY
        self.move()
        


    }
    
}