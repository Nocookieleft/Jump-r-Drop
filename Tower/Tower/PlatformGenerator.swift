//
//  PlatformGenerator.swift
//  Tower
//
//  Created by Evil Cookie on 08/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//
//

import Foundation
import SpriteKit


class PlatformGenerator : SKSpriteNode {
    
    var generationTimer : NSTimer?
    var platformGround : Platform!
    var platforms = [Platform]()
    
    var backgroundTest : SKNode!
    var finishLine = SKSpriteNode(imageNamed: "carrot")
    
    // make the first platform to fill the ground floor at the start of the game
    func addGround(groundWidth: CGFloat){
        backgroundTest = SKSpriteNode(texture: nil, size: frame.size)
        backgroundTest.position = CGPointMake(0, 0)
        addChild(backgroundTest)
        
        //set the first platform according to the coordinatesystem of the backgroundTest
        platformGround = Platform(size: CGSizeMake(groundWidth, kPlatformHeight))
        platformGround.position = convertPoint(CGPoint(x: 0, y: -size.height/2 + platformGround.size.height/2), toNode: backgroundTest)
        platformGround.zPosition = 3
        platformGround.name = "groundFloor"
        
        backgroundTest.addChild(platformGround)
    }

    // speed up the movement of the platforms and finishline
    func adjustSpeed(stringKey: String){
        var addedSpeed = -kDefaultSpeed * 2
        
        for eachChild in backgroundTest.children
        {
            if let anyMovingSprite = (eachChild as? SKSpriteNode)
            {
                if anyMovingSprite.hasActions()
                {
                    if stringKey == "speedUp"
                    {
                        anyMovingSprite.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: addedSpeed, duration: 1.0)), withKey: stringKey)
                    }
                    else if stringKey == "slowDown"
                    {
                        anyMovingSprite.removeActionForKey(stringKey)
                    }
                }
            }
        }
    }

    
    // helper function to quickly give a position float within a certain range
    func rangeFloat(min : CGFloat, max: CGFloat) -> CGFloat {
        var positionInRange = CGFloat(arc4random_uniform(UInt32(max))) % max + min
        // * (max - min)
        return positionInRange
    }
    
    
    
    // load carrot at the top of the screen with physics set to let it float in midair and register contact from playerCategory
    func loadFinishLine(){
        finishLine.size = CGSizeMake(kPlayerHeight * 0.9, kPlayerHeight * 0.9)
        finishLine.position = convertPoint(CGPoint(x: 0, y: size.height * 1.5), toNode: backgroundTest)
        finishLine.zPosition = 3
        finishLine.name = "finishLine"
        
        // set gravitational properties and other forces
        finishLine.physicsBody = SKPhysicsBody(rectangleOfSize: finishLine.size)
        finishLine.physicsBody?.affectedByGravity = false
        finishLine.physicsBody?.dynamic = false
        finishLine.physicsBody?.categoryBitMask = finishLineCategory
        finishLine.physicsBody?.contactTestBitMask = playerCategory
        finishLine.physicsBody?.collisionBitMask = finishLineCategory
        // add finishline to the backgroundNode
        backgroundTest.addChild(finishLine)

    }
    
    
    // generate some platforms on the scene
    func populate(screenWidth: CGFloat, num: Int){
        let maxX = kMaxX - kMinX
        
        var formerX = CGFloat(0)
        for (var i = 0 ; i < num; i++)
        {
            // populate the screen with platforms spaced some platformheight from eachother
            // and at a random position horizontally within the bounds of the screen
            var otherY = CGFloat(i) * (kPlayerHeight * 2.5)
            let platform = Platform(size: CGSizeMake(kPlatformWidth, kPlatformHeight))
            let x = rangeFloat(0, max: maxX)
            let y = otherY + kfloorDistance - size.height/2
            
            // if a platform is about to be positioned at the same x as the one before it,
            // give the platform another position
            if (formerX == x || formerX + kPlatformWidth/2 > x)
            {
                platform.position = convertPoint(CGPoint(x: (x - kPlatformWidth * 2 % maxX/2), y: y), toNode: backgroundTest)
                 println(" Other platform is set to  \(platform.position)")
                println("\(x) en former x is \(formerX)")
            }
            else
            {
                platform.position = convertPoint(CGPoint(x: x % maxX/2, y: y), toNode: backgroundTest)
                println(" platform is positioned at \(platform.position)")
            }
            
            platform.zPosition = platformZposition
            formerX = platform.position.x
            platforms.append(platform)
            backgroundTest.addChild(platform)
            
            let platformSmall = Platform(size: CGSizeMake(kPlatformWidth * 0.5, kPlatformHeight))
            
            // set small platform at left or right side of the platform according to the position of the larger platform
            if (platform.position.x + kPlatformWidth > maxX/2)
            {
                platformSmall.position = convertPoint(CGPoint(x: (x + kPlatformWidth + kGapDistance) % 160 * -1, y: y),toNode: backgroundTest)
                println(" Small platform is positioned at \(platformSmall.position)")
            }
            else
            {
                platformSmall.position = convertPoint(CGPoint(x: x + kGapDistance % 160 , y: y),toNode: backgroundTest)
                println(" Small platform 2 is positioned at \(platformSmall.position)")
            }
    
            platformSmall.zPosition = 3
            platforms.append(platformSmall)
            backgroundTest.addChild(platformSmall)
            
            // when almost done populating with platforms, load in the carrot as finisline
            if i + 1 == num
            {
                loadFinishLine()
            }
            
        }
    }

    

    
    // start moving all the platforms and gaps in the screen
    func startMovingAll(){
        if (platformGround != nil)
        {
            platformGround.startMoving()
        }
        for eachPlatform in platforms {
            if (!eachPlatform.isMoving)
            {
                eachPlatform.startMoving()
            }
        }
        
        for eachChild in backgroundTest.children {
            if  let anyName = (eachChild as! SKSpriteNode).name
            {
                if anyName == "gap" || anyName == "finishLine"
                {
                    if !eachChild.hasActions()
                    {
                        eachChild.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -kDefaultSpeed, duration: 1.0)))
                    }
                }
            }
        }
        if backgroundTest.position.y < 0
        {
            backgroundTest.position.y + size.height
        }
    }
    
    
    // stop generating platforms by invalidating the timer
    func stopGenerating(){
        generationTimer?.invalidate()
    }
    
    
    // stop all generation and movement of platforms and gaps
    func stopAll(){
        stopGenerating()
        backgroundTest.removeAllActions()
        for eachPlatform in platforms {
            eachPlatform.stopMoving()
        }
        
        for eachChild in backgroundTest.children {
            if let anyName = (eachChild as! SKSpriteNode).name
            {
                if (anyName == "finishLine" || anyName == "gap")
                {
                    if eachChild.hasActions()
                    {
                        eachChild.removeAllActions()
                    }
                }
            }
        }
        

    }
    
}