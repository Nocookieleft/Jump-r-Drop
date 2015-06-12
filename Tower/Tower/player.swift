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
    var scaleX = CGFloat(1.0)
    var baseLine = CGFloat(0)
    var minX = kMinX
    var maxX = kMaxX
    var isIdle = false
    
    init(imageNamed: String) {
       // render 
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: nil, size: CGSizeMake(kPlayerHeight, kPlayerHeight))
        
        
        // use physicsbody to simulate gravity and stuff on player avatar
        loadPhysicsBody(CGSizeMake(kPlayerHeight, kPlayerHeight - 10 ))
        
    }
    
    // load physics body properties
    func loadPhysicsBody(size: CGSize){
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.contactTestBitMask = platformCategory
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1
        

    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // constrain player position when landed on ground or hit frame boundaries
    func constrainPosition(){
        
        if (self.position.y < self.baseLine)
        {
            self.position.y = self.baseLine
            self.ground()
        }
        
        if (self.position.x > maxX)
        {
            self.position.x = maxX
            self.turn()
            
        }else if (self.position.x < minX)
        {
            self.position.x = minX
            self.turn()
        }
        
    }
    
    
    func resetBaseLine(newPosition: CGFloat){
        baseLine = newPosition + kPlatformHeight 
    }
    
    // flip the avatar horizontally when bumping into the frame boundaries
    func turn(){
    
        if (isFacingRight == true)
        {
            scaleX = -1.0
            
        }else
        {
            scaleX = 1.0
        }
        
        let turn = SKAction.scaleXTo(scaleX, duration: 0.1)
        self.runAction(turn, completion: { () -> Void in
        self.isFacingRight = !self.isFacingRight})
        
    }
    
    
    
    // stop jumping of the player
    func ground(){
        
        velocityY = 0.0
       // velocityX = self.size.width/6
        self.isGrounded = true
    }
    
    
    // begin avatar jump if player is on the ground
    func jump(){
        if (self.isGrounded == true)
        {
            velocityY = -10
            velocityX - 2
            isGrounded = false
        }

    }
    
    
    // let avatar move horizontally by the way it is positioned and its velocity
    func move(){
        
        let actionWait = SKAction.waitForDuration(0.1)
        
        let repostion = SKAction.moveByX(scaleX * (velocityX), y: 0, duration: 0.1)
        self.runAction(repostion, completion: { () -> Void in
            self.runAction(actionWait)
            })
    }
    
    

    
    // set variables at starting point
    func start(){
        velocityX = self.size.width/6
        
    }
    
    func stop(){
        self.removeAllActions()
    }
    
    
    // make avatar slow down jumping animation
    func slowDownJump(){
        if (self.velocityY < -6.0)
        {
            self.velocityY = -6.0
            self.velocityX + 2
        }
    }
    
    
    // update position of the player
    func update(){
        if (isIdle == false)
        {
            self.velocityY += self.gravity
            self.position.y -= velocityY
            self.move()
            self.constrainPosition()
        }
        else
        {
            stop()
        }

    }
    
}

