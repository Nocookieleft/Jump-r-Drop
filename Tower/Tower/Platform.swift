
//
//  Platform.swift
//  Tower
//
//  Created by Evil Cookie on 05/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import SpriteKit


class Platform: SKShapeNode {
    
    let PLATFORM_WIDTH : CGFloat = 100
    
    init(size: CGSize) {
        // render the platforms by path
        super.init()
        let path = CGPathCreateWithRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), nil)
        self.path = path
        self.fillColor = UIColor.brownColor()
        
        // use physicsbody to simulate gravity, should not happen for platforms
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.categoryBitMask = platformCategory
        self.physicsBody?.contactTestBitMask = playerCategory
        self.physicsBody?.affectedByGravity = false
      //  self.physicsBody?.dynamic = false
        
        
    }

    func startMoving(){
        let moveUp = SKAction.moveByX(0, y: -kPlatformHeight , duration: 1.0)
        runAction(SKAction.repeatActionForever(moveUp))
    }
    
    func stopMoving(){
        self.removeAllActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

