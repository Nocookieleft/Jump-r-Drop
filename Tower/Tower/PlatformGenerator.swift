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
    var platforms = [Platform]()
    
    func populate(groundWidth: CGFloat, playerHeight: CGFloat, num: Int){
        
        // make the first platform to fill the ground floor at the start of the game
        let platformGround = Platform(size: CGSizeMake(groundWidth, kPlatformHeight))
        platformGround.position = CGPoint(x: 0, y: 0)
        platformGround.zPosition = 2
        addChild(platformGround)
        
        var formerX = CGFloat(0)
        
        for (var i = 0 ; i < num; i++)
        {
            // populate the screen with platforms spaced some platformheight from eachother
            // and at a random position horizontally within the bounds of the screen
            var otherY = CGFloat(i) * kPlatformHeight
            let platform = Platform(size: CGSizeMake(PLATFORM_WIDTH, kPlatformHeight))
            let x = CGFloat(arc4random_uniform(UInt32(groundWidth)))
            let y = otherY * 2 + (kPlayerHeight * 2)
           
            // if a platform is about to be positioned at the same x as the one before it,
            // give the platform another position
            if (formerX == x)
            {
                platform.position = CGPoint(x: x + PLATFORM_WIDTH % kMaxX, y: y)
            }
            else
            {
                platform.position = CGPoint(x: x, y: y)
            }
            
            platform.zPosition = 2
            formerX = x
            addChild(platform)
            
        }
    }
    
    
    
    
    // generate a platform at the top of the screen
    func generatePlatform(){
        let newPlatform = Platform(size: CGSizeMake(PLATFORM_WIDTH, kPlatformHeight))
        let x = CGFloat(arc4random_uniform(UInt32(kMaxX))) - kMinX
        let y = kPlatformHeight + frame.size.height
        
        newPlatform.position = CGPointMake(x, y)
        newPlatform.zPosition = 2
        platforms.append(newPlatform)
        addChild(newPlatform)
        newPlatform.startMoving()
    }
    
    // call upon the generator every some seconds
    func startGeneratingEvery(seconds: NSTimeInterval){
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "generatePlatform", userInfo: nil, repeats: true)
    }
    
    // stop generating platforms by invalidating the timer
    func stopGenerating(){
        generationTimer?.invalidate()
    }
    
    func stopAll(){
        stopGenerating()
        for eachPlatform in platforms {
            eachPlatform.stopMoving()
        }
    }
    
}