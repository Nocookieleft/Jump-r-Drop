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
    var isAlive = true
    
    init(imageNamed: String) {
       // render 
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: nil, size: CGSizeMake(kPlayerHeight, kPlayerHeight))
        
    }
    
    // load physics body properties
    func loadPhysicsBody(size: CGSize){
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.contactTestBitMask = platformCategory | upperTresholdCategory | lowerTresholdCategory | rockBottomCategory
        self.physicsBody?.collisionBitMask = playerCategory | platformCategory
        
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.restitution = 0.4
        self.physicsBody?.linearDamping = 0.2
        self.physicsBody?.friction = 0.0

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
        
        self.isGrounded = true
    }
    
    
    // begin avatar jump if player is on the ground
    func jump(){
        if (self.isGrounded == true)
        {
            let velocity_x = self.physicsBody?.velocity.dx
            let velocity_y = self.physicsBody?.velocity.dy
            
            self.physicsBody?.applyImpulse(CGVectorMake(velocity_x!, 40))

            isGrounded = false
        }

    }
    
    
    // let avatar move horizontally translating when the sprite is drawn negative
    func move(){
        
        let actionWait = SKAction.waitForDuration(0.1)
        let repostion = SKAction.moveByX(scaleX * (velocityX), y: 0, duration: 0.1)
        self.runAction(repostion, completion: { () -> Void in
            self.runAction(actionWait)
            })
    }
    
    
//    func pause(){
//        self.removeAllActions()
//        
//    }
    
    
    // set speed and gravity forces on avatar at the beginning of the game
    func start(){
        velocityX = self.size.width/8
        loadPhysicsBody(CGSizeMake(kPlayerHeight, kPlayerHeight))
    }
    
    // stop all actions of the avatar and remove its node
    func stop(){
        self.removeAllActions()
        self.removeFromParent()
        
    }
    
    
    // make avatar slow down jumping animation
    func slowDownJump(){
        if (self.velocityY < -6.0)
        {
            self.velocityY = -6.0

        }
    }
    
    
    // update position of the player
    func update(){
        if (isAlive == true)
        {

            self.move()
            self.constrainPosition()
        }
        else
        {
            stop()
        }

    }
    
}

