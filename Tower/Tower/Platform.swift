
//
//  Platform.swift
//  Tower
//
//  Created by Evil Cookie on 05/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import SpriteKit


class Platform: SKSpriteNode {
    
    var isMoving = false
    
    
    init(size: CGSize) {
        // render the platforms by path
        let platformTexture = SKTexture(imageNamed: "floor")
        super.init(texture: platformTexture, color: nil, size: size)
        
//        let path = CGPathCreateWithRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), nil)
//        self.path = path
//        self.fillColor = UIColor.brownColor()
        
        
        
        // use physicsbody to simulate gravity, should not happen for platforms
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.physicsBody?.categoryBitMask = platformCategory
//        self.physicsBody?.contactTestBitMask = playerCategory
        self.physicsBody?.collisionBitMask = platformCategory
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.dynamic = false
        
    }

    // start moving platform down the screen
    func startMoving(){
        let moveDown = SKAction.moveByX(0, y: -kPlatformHeight/2 , duration: 1.0)
        runAction(SKAction.repeatActionForever(moveDown))
        isMoving = true
    }
    
    // stop platform from moving
    func stopMoving(){
        if self.hasActions()
        {
            self.removeAllActions()
            isMoving = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

