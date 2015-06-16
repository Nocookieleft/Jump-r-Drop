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
    
    
    let PLATFORM_WIDTH : CGFloat = 100
    var generationTimer : NSTimer?
    var platformGround : Platform!
    var platforms = [Platform]()
    var floorDistance : CGFloat = 60
    var backgroundTest : SKNode!
    
    
    // make the first platform to fill the ground floor at the start of the game
    func addGround(groundWidth: CGFloat){
    
        platformGround = Platform(size: CGSize(width: groundWidth, height: kPlatformHeight))
        platformGround.position = CGPoint(x: 0, y: 0)
        platformGround.zPosition = 2
        addChild(platformGround)
        
        
    }

    // helper function to quickly give a position float within a certain range
    func rangeFloat(min : CGFloat, max: CGFloat) -> CGFloat {
        var positionInRange = CGFloat(arc4random_uniform(UInt32(max))) * (max - min) % max
        return positionInRange
    }
    
    
    // generate some platforms on the scene
    func populate(screenWidth: CGFloat, num: Int){
        
        var formerX = CGFloat(0)
        for (var i = 0 ; i < num; i++)
        {
            // populate the screen with platforms spaced some platformheight from eachother
            // and at a random position horizontally within the bounds of the screen
            var otherY = CGFloat(i) * (kPlatformHeight * 1.8)
            let platform = Platform(size: CGSizeMake(PLATFORM_WIDTH, kPlatformHeight))
            let x = rangeFloat(kMinX, max: kMaxX)
            let y = otherY * 2 + kPlayerHeight
            
            // if a platform is about to be positioned at the same x as the one before it,
            // give the platform another position
            if (formerX == x)
            {
                platform.position = CGPoint(x: (x + PLATFORM_WIDTH) % kMaxX + x, y: y)
            }
            else
            {
                platform.position = CGPoint(x: x, y: y)
            }
            
            platform.zPosition = 2
            formerX = x
            platforms.append(platform)
            addChild(platform)
            
            
            let platformSmall = Platform(size: CGSizeMake(PLATFORM_WIDTH * 0.8, kPlatformHeight))
            platformSmall.position = CGPoint(x: (x - PLATFORM_WIDTH * 2) % screenWidth + kMinX, y: y)
            platformSmall.zPosition = 2
            platforms.append(platformSmall)
            addChild(platformSmall)
            
        }
    }
    
    
    func startGen2(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.runBlock{ self.otherPLatformgenerator()}])))
    }
    
    
    // try another platform generator
    func otherPLatformgenerator() {
        let rightPlatform = Platform(size: CGSizeMake(rangeFloat(kMinX, max: kMaxX), kPlatformHeight))
        rightPlatform.position = convertPoint(CGPoint(x: kMinX, y: CGRectGetMinY(frame) + size.height + floorDistance), toNode: backgroundTest)
        
        rightPlatform.zPosition = 2
        platforms.append(rightPlatform)
        backgroundTest.addChild(rightPlatform)
        
        // create a gap in between the platforms from left to right
        let gapInBetween = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: kPlayerHeight * 2, height: kPlatformHeight))
        gapInBetween.position = convertPoint(CGPoint(x: kMinX + rightPlatform.size.width , y: rightPlatform.position.y), toNode: backgroundTest)
        gapInBetween.zPosition = 2
        backgroundTest.addChild(gapInBetween)
        
        // set the platform on the other side of the gap
        let leftPlatform = Platform(size: CGSizeMake(rangeFloat(kMinX, max: kMaxX), kPlatformHeight))
        leftPlatform.position = convertPoint(CGPoint(x: kMinX + rightPlatform.size.width + gapInBetween.size.width, y: rightPlatform.position.y), toNode: backgroundTest)
        leftPlatform.zPosition = 2
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
    }
    
}