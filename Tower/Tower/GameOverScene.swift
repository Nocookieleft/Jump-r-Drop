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
    
    let GOMessage = SKLabelNode(fontNamed: "Noteworthy")
    let NGButton = SKLabelNode(fontNamed: "Muli")
    
    override func didMoveToView(view: SKView) {
        // setup scene
        backgroundColor = kColorLightBlue
        GOMessage.text = "Game Over"
        GOMessage.fontColor = kColorDeepDarkBlue
        GOMessage.position = CGPoint(x: view.center.x, y: (view.frame.height * 0.6))
        addChild(GOMessage)
        
        // show a menu
        let menuNode = SKShapeNode(rectOfSize: CGSizeMake(view.frame.width/2, view.frame.height*0.5))
        menuNode.position = view.center
        menuNode.fillColor = kColorDarkBlue
        addChild(menuNode)
        
        // make a button shape to indicate that the user can click here
        let buttonNode = SKShapeNode(rectOfSize: CGSizeMake(menuNode.frame.width * 0.9, 60))
        buttonNode.position = CGPointMake(view.center.x, (menuNode.frame.height * 0.8))
        buttonNode.fillColor = kColorDarkBlue
        addChild(buttonNode)
        
        // show a "New Game" label node
        NGButton.name = "NewGame"
        NGButton.fontColor = kColorDeepDarkBlue
        NGButton.fontSize = (GOMessage.fontSize * 0.8)
        NGButton.text = "New Game"
        NGButton.position = CGPointMake(menuNode.position.x, (buttonNode.position.y - 6))
        addChild(NGButton)

        
    }
    
    // restart the game by going to the gamescene
    func restartGame(){
        if let newScene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            
            let newView = self.view! as SKView
            
            newScene.size = CGSizeMake(view!.bounds.size.width, view!.bounds.size.height)
            /* Set the scale mode to scale to fit the window */
            newScene.scaleMode = .AspectFill
            
            newView.presentScene(newScene)
        }else
        {
            println("shit didn't happen")
        }
    }
    
    
    // restart the game if the user touches New Game node
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // check for each touch if any menu nodes are touched by checking location
        for touch: AnyObject in touches {
           
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            if let nodeName = touchedNode.name {
            
                if (nodeName == "NewGame")
                {
                    println("User tapped New Game")
                    restartGame()
                    
                    
                }else
                {
                    println("nothing here")
                }
            }
        }

    }
    
    
}