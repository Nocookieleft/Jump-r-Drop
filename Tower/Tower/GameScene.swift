//
//  GameScene.swift
//  Tower
//
//  Created by Evil Cookie on 01/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed:"Player")

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.whiteColor()
        // spawn player and setup properties
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player)
    }
    
    func movePlayer(){
        
        let actionMoveLeft = SKAction.moveToX(-player.size.width/2, duration: 2.0)
        let actionMoveRight = SKAction.moveToX(+player.size.width/2, duration: 2.0)
        // if player is positioned to the left of the center x
        if (player.position.x <= (size.width + player.size.width/2))
        {
            player.runAction(actionMoveLeft)
            
        
        }else if (player.position.x >=  (size.width + player.size.width/2))
        {
            player.runAction(actionMoveRight)
        }
        
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Welcome to Tower!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        
//        for touch in (touches as! Set<UITouch>) {
//            let location = touch.locationInNode(self)
//            
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
//    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
