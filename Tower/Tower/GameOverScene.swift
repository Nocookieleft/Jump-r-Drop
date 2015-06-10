//
//  GameOverScene.swift
//  Tower
//
//  Created by Evil Cookie on 09/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    
    let GOMessage = SKLabelNode(fontNamed: "Montserrat")
    
    override func didMoveToView(view: SKView) {
        // setup scene
        backgroundColor = UIColor(red: 204.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        GOMessage.text = "Game Over"
        GOMessage.color = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1)
        GOMessage.position = view.center
        addChild(GOMessage)
    }
    
    
    
    
    
    
}