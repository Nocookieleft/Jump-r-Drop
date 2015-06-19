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
    var floorDistance : CGFloat = 40
    var backgroundTest : SKNode!
    
    
    // make the first platform to fill the ground floor at the start of the game
    func addGround(groundWidth: CGFloat){
        
        backgroundTest = SKSpriteNode(texture: nil, size: frame.size)
        backgroundTest.position = CGPointMake(0, 0)
        addChild(backgroundTest)
        
        platformGround = Platform(size: CGSizeMake(groundWidth, kPlatformHeight))
//        platformGround.position = CGPoint(x: 0, y: kPlatformHeight/2)
        platformGround.position = convertPoint(CGPoint(x: 0, y: -size.height/2), toNode: backgroundTest)
        
        platformGround.zPosition = 3
        platformGround.name = "groundFloor"
//        addChild(platformGround)
        println("\(platformGround.position)")
        
        backgroundTest.addChild(platformGround)
    }

    // helper function to quickly give a position float within a certain range
    func rangeFloat(min : CGFloat, max: CGFloat) -> CGFloat {
        var positionInRange = CGFloat(arc4random_uniform(UInt32(max))) //* (max - min) % max
        return positionInRange
    }
    
    
    // generate some platforms on the scene
    func populate(screenWidth: CGFloat, num: Int){
        
        var formerX = CGFloat(0)
        for (var i = 0 ; i < num; i++)
        {
            // populate the screen with platforms spaced some platformheight from eachother
            // and at a random position horizontally within the bounds of the screen
            var otherY = CGFloat(i) * (kPlatformHeight * 1.6)
            let platform = Platform(size: CGSizeMake(PLATFORM_WIDTH, kPlatformHeight))
            let x = rangeFloat(kMinX, max: kMaxX)
            let y = otherY * 2 + kPlayerHeight * 2 - size.height/2
            
            // if a platform is about to be positioned at the same x as the one before it,
            // give the platform another position
            if (formerX == x)
            {
                platform.position = convertPoint(CGPoint(x: (x + PLATFORM_WIDTH) % kMaxX , y: y), toNode: backgroundTest)
            }
            else
            {
                platform.position = convertPoint(CGPoint(x: x, y: y), toNode: backgroundTest)
            }
            
            platform.zPosition = 3
            formerX = x
            platforms.append(platform)
            backgroundTest.addChild(platform)
            
            
            let platformSmall = Platform(size: CGSizeMake(PLATFORM_WIDTH * 0.8, kPlatformHeight))
            platformSmall.position = convertPoint(CGPoint(x: (x - PLATFORM_WIDTH * 2) % kMaxX + kMinX, y: y),toNode: backgroundTest)
            
            
            platformSmall.zPosition = 3
            platforms.append(platformSmall)
            backgroundTest.addChild(platformSmall)
            
        }
    }
    
    // check how many platforms are in play and generate if there are less than 18 on screen
    func startGen2(){
        var platformLimit = 20
        for eachChild in backgroundTest.children
        {
            if eachChild.name == "platform"
            {
                platformLimit--
            }
            
        }
        if platformLimit > 0
        {
            runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.runBlock{ self.otherPLatformgenerator()}])))
        }
    }
    
    
    // try another platform generator to make platform-gap-platform sequence running along the x-axis of the screen
    func otherPLatformgenerator() {
        
        let rightPlatform = Platform(size: CGSizeMake(rangeFloat(kMinX, max: kMaxX - kPlayerHeight), kPlatformHeight))
        rightPlatform.position = convertPoint(CGPoint(x: -size.width/2, y: CGRectGetMinY(frame) + floorDistance + size.height/2), toNode: backgroundTest)
        println("position rightplatform is \(rightPlatform.position.x)")
        
        rightPlatform.zPosition = 3
//        rightPlatform.name = "platform"
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
//        leftPlatform.name = "platform"
        platforms.append(leftPlatform)
        backgroundTest.addChild(leftPlatform)
    
        
    }
    
    
    
    // generate a platform at the top of the screen
    func generatePlatform(){
        let newPlatform = Platform(size: CGSizeMake(PLATFORM_WIDTH, kPlatformHeight))
        let x = rangeFloat(kMinX, max: kMaxX)
        let y = kPlatformHeight + frame.size.height
    
        newPlatform.name = "platform"
        newPlatform.position = CGPointMake(x, y)
        newPlatform.zPosition = 2
        platforms.append(newPlatform)
        addChild(newPlatform)
    }
    
    
//    // call upon the generator every some seconds
//    func startGeneratingEvery(seconds: NSTimeInterval){
//        generationTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "generatePlatform", userInfo: nil, repeats: true)
//    }
    

    
    // start moving all the platforms in the screen
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
            if (eachChild.name == "gap")
            {
                if !eachChild.hasActions()
                {
                    eachChild.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -kPlatformHeight/2, duration: 1.0)))
                }
            }
        }
    }
    
    
//    // stop generating platforms by invalidating the timer
//    func stopGenerating(){
//        generationTimer?.invalidate()
//    }
    
    func stopAll(){
//        stopGenerating()
        for eachPlatform in platforms {
            eachPlatform.stopMoving()
        }
        
        for eachChild in backgroundTest.children {
            if (eachChild.name == "gap")
            {
                if eachChild.hasActions()
                {
                    eachChild.removeAllActions()
                }
            }
        }
        

    }
    
}