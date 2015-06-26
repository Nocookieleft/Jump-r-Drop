//
//  MovingLevel.swift
//  Tower
//
//  Created by Evil Cookie on 02/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//
// The background of the game, looking like a stack of alternating colored bars that continuously move down the screen once the game has started


import Foundation
import SpriteKit


class MovingLevel : SKSpriteNode {
    
    // make the height double size of the frame to extend it up offscreen
    init(size: CGSize) {
        super.init(texture: nil, color: kColorLightBlue, size: CGSizeMake(size.width, size.height * 2))
        anchorPoint = CGPointMake(0, 0)
        
        for (var i = 0; i < kSegmentNumber; i++)
        {
            // make the color differ from segment to segment to distinguish them from another
            // even numbered segments get color one, odd segments get color two
            var segmentColor: UIColor!
            if (i % 2 == 0)
            {
                segmentColor = kColorLightBlue
            }else
            {
                segmentColor = kColorDarkBlue
            }
            
            // position segments one after another stacking according to their number and size height
            let segment = SKSpriteNode(color: segmentColor, size: CGSizeMake(self.size.width, self.size.height / CGFloat(kSegmentNumber)))
            segment.anchorPoint = CGPointMake(0, 0)
            segment.position = CGPointMake(0, CGFloat(i) * segment.size.height)
            segment.zPosition = 1
            addChild(segment)
        }
        
    }
    

    // let the background move
    func start(){
        moveBG()
    }
    

    
    // move the frame down over the screen and reset position to make illusion of neverending level
    func moveBG() {
        let adjustedDuration = NSTimeInterval(frame.size.height / kDefaultSpeed)
        let moveUp = SKAction.moveByX(0.0, y: -frame.size.height / 2 , duration: adjustedDuration / 2)
        let resetPosition = SKAction.moveToY(0.0, duration: 0.0)
        runAction(SKAction.repeatActionForever(SKAction.sequence([moveUp, resetPosition])))
    }
    
    
    // stop all actions on this sprite
    func stop(){
        self.removeAllActions()
    }
    
    
    
    // update the scene
    func update(currentTime: CFTimeInterval){

    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}