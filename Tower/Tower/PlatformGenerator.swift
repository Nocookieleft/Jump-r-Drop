//
//  PlatformGenerator.swift
//  Tower
//
//  Created by Evil Cookie on 08/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import SpriteKit


class PlatformGenerator : SKSpriteNode {
    
    
    let PLATFORM_WIDTH : CGFloat = 120
    var generationTimer : NSTimer?
    var platformGround : Platform!
    var platforms = [Platform]()
    var floorDistance : CGFloat = 100
    var backgroundTest : SKNode!
    var carrotNode = SKSpriteNode(imageNamed: "carrot")
    
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
        carrotNode.size = CGSizeMake(30, 30)
        carrotNode.position = convertPoint(CGPoint(x: 0, y: size.height * 1.2), toNode: backgroundTest)
        carrotNode.zPosition = 3
        carrotNode.name = "finishLine"

        carrotNode.physicsBody = SKPhysicsBody(rectangleOfSize: carrotNode.size)
        carrotNode.physicsBody?.affectedByGravity = false
        carrotNode.physicsBody?.dynamic = false
        carrotNode.physicsBody?.categoryBitMask = finishLineCategory
        carrotNode.physicsBody?.contactTestBitMask = playerCategory
        carrotNode.physicsBody?.collisionBitMask = finishLineCategory
        
        backgroundTest.addChild(carrotNode)

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
            let platform = Platform(size: CGSizeMake(PLATFORM_WIDTH, kPlatformHeight))
            let x = rangeFloat(0, max: maxX)
            let y = otherY + floorDistance - size.height/2
            
            // if a platform is about to be positioned at the same x as the one before it,
            // give the platform another position
            if (formerX == x || formerX + PLATFORM_WIDTH/2 > x)
            {
                platform.position = convertPoint(CGPoint(x: (x - PLATFORM_WIDTH * 2 % maxX/2), y: y), toNode: backgroundTest)
                 println(" Other platform is set to  \(platform.position)")
                println("\(x) en former x is \(formerX)")
            }
            else
            {
                platform.position = convertPoint(CGPoint(x: x % maxX/2, y: y), toNode: backgroundTest)
                println(" platform is positioned at \(platform.position)")
            }
            
            platform.zPosition = 3
            formerX = platform.position.x
            platforms.append(platform)
            backgroundTest.addChild(platform)
            
            let platformSmall = Platform(size: CGSizeMake(PLATFORM_WIDTH * 0.5, kPlatformHeight))
            
            // set small platform at left or right side of the platform according to the position of the larger platform
            if (platform.position.x + PLATFORM_WIDTH > maxX/2)
            {
                platformSmall.position = convertPoint(CGPoint(x: (x + PLATFORM_WIDTH + kGapDistance) % 160 * -1, y: y),toNode: backgroundTest)
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
    
    // check how many platforms are in play and generate if there are less than 18 on screen
    func startGen2(){
        var platformLimit = 20
        for eachChild in backgroundTest.children
        {
            if let anyName = (eachChild as! SKSpriteNode).name
            {
                if anyName == "platform"
                {
                    platformLimit--
                }
            }
        }
        if platformLimit > 0
        {
//            runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(2.0), SKAction.runBlock{ self.otherPLatformgenerator()}])))
            runAction(SKAction.repeatAction(SKAction.sequence([SKAction.waitForDuration(4.0), SKAction.runBlock{ self.populate(self.frame.size.width, num: 1)}]), count: platformLimit))
            
        }
    }
    
    
    // try another platform generator to make platform-gap-platform sequence running along the x-axis of the screen
    func otherPLatformgenerator() {
        
        let rightPlatform = Platform(size: CGSizeMake(rangeFloat(kMinX, max: kMaxX - kPlayerHeight), kPlatformHeight))
        rightPlatform.position = convertPoint(CGPoint(x: -size.width/2, y: rightPlatform.size.height/2), toNode: backgroundTest)
        println("position rightplatform is \(rightPlatform.position.x)")
        
        rightPlatform.zPosition = 3
        platforms.append(rightPlatform)
        backgroundTest.addChild(rightPlatform)
        
        // create a gap in between the platforms from left to right
        let gapInBetween = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(kPlayerHeight * 2, kPlatformHeight))
        gapInBetween.position = convertPoint(CGPoint(x: -rightPlatform.size.width/2 - gapInBetween.size.width/2 , y: rightPlatform.position.y), toNode: backgroundTest)
        gapInBetween.zPosition = 3
        gapInBetween.name = "gap"
        backgroundTest.addChild(gapInBetween)
        
        
        // set the platform on the other side of the gap
        let leftPlatform = Platform(size: CGSizeMake( CGFloat((frame.size.width - rightPlatform.size.width - gapInBetween.size.width ) + kMinX), kPlatformHeight))
        println("left platform width is \(leftPlatform.size.width)")
        
        leftPlatform.position = convertPoint(CGPoint(x: (rightPlatform.size.width + gapInBetween.size.width)/2, y: rightPlatform.position.y), toNode: backgroundTest)
        leftPlatform.zPosition = 3
        platforms.append(leftPlatform)
        backgroundTest.addChild(leftPlatform)
    
        
    }
    
    
    
    // generate a platform at the top of the screen
    func generatePlatform(){
        let newPlatform = Platform(size: CGSizeMake(PLATFORM_WIDTH, kPlatformHeight))
        let x = rangeFloat(kMinX, max: kMaxX)
        let y = kPlatformHeight
    
        newPlatform.position = CGPointMake(x, y + frame.size.height)
        println(" GENERATED PLATFORM AT \(newPlatform.position)")
        newPlatform.zPosition = 3
        platforms.append(newPlatform)
        addChild(newPlatform)
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