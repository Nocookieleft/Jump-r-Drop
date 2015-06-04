//
//  MovingLevel.swift
//  Tower
//
//  Created by Evil Cookie on 02/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import SpriteKit

class MovingLevel : SKSpriteNode {
    
    let NUMBER_OF_SEGMENTS = 20
    let COLOR_ONE = UIColor(red: 204.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    let COLOR_TWO = UIColor(red: 153.0/255, green: 245.0/255, blue: 246.0/255.0, alpha: 1.0)
    
    var isMoving = false
    var currentInterval = UInt32(0)
    var timeGapForNextLvl = UInt32(0)
    
    
    // make the height double size of the frame to extend it from the
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(red: 204.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0), size: CGSizeMake(size.width, size.height * 2))
        anchorPoint = CGPointMake(0.5, 0)
        
        for (var i = 0; i < NUMBER_OF_SEGMENTS; i++)
        {
            // make the color differ from segment to segment to distinguish them from another
            // even numbered segments get color one, odd segments get color two
            var segmentColor: UIColor!
            if (i % 2 == 0)
            {
                segmentColor = COLOR_ONE
            }else
            {
                segmentColor = COLOR_TWO
            }
            
            // position segments one after another stacking according to their number and size height
            let segment = SKSpriteNode(color: segmentColor, size: CGSizeMake(self.size.width, self.size.height / CGFloat(NUMBER_OF_SEGMENTS)))
            segment.anchorPoint = CGPointMake(0, 0)
            segment.position = CGPointMake(0, CGFloat(i) * segment.size.height)
            addChild(segment)
            
        }
        
    }
    
    func stopMoving(){
        let resetPosition = SKAction.moveToY(0.0, duration: 0)
        runAction(resetPosition)
        isMoving = false
    }
    
    
    func shouldProgress() -> Bool {
        if (isMoving == false)
        {
            return true
        }
        return false
        
//        if (currentInterval > timeGapForNextLvl)
//        {
//            return true
//        }
//        return false
    }
    
    func progress() {
       // move the frame down over the screen and reset position to make illusion of neverending level
        let moveUp = SKAction.moveByX(0.0, y: -frame.size.height/10, duration: 2.0)
        runAction(moveUp)
        isMoving = true
        //let resetPosition = SKAction.moveToY(0.0, duration: 0)
    //    runAction(SKAction.sequence([moveUp, resetPosition]))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}