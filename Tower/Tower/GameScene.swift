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
    var towerLvl: Int = 1
    let floor = SKSpriteNode(imageNamed:"floor")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.whiteColor()
        // spawn player and setup properties
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player)
        floor.position = CGPoint(x: size.width * 0.1, y: size.height * 0.05)
        addChild(floor)
        let ground = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: size.width, height: 20))
        ground.position = CGPoint(x: size.width/2, y: size.height * 0.05)
        addChild(ground)
        movePlayer()
    }
    
    func movePlayer(){
        let minX = player.size.width / 2
        let maxX = self.frame.size.width - player.size.width / 2
        let actionMoveLeft = SKAction.moveByX(1.0, y: 0.0, duration: 2.0)
      //  let actionMoveRight = SKAction.movebyX(+player.size.width/2, duration: 2.0)
        
        // if player is positioned to the left of the center x
        //if (player.position.x < maxX)
        //{
           player.runAction(SKAction.repeatActionForever(actionMoveLeft))
        
        //}
        //player.runAction(actionMoveRight)
//        
//        if (player.position.x >= minX)
//        {
//            player.runAction(actionMoveRight)
//        }
//        
//        //old
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Welcome to Tower!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        
//        for touch in (touches as! Set<UITouch>) {
//            
//                 .position = location
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
