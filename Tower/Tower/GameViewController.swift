//
//  GameViewController.swift
//  Tower
//
//  Created by Evil Cookie on 01/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
             
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}


class GameViewController: UIViewController {

    var sWidth = CGFloat(0)
    var sHeight = CGFloat(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* render the portrait mode to set correct boundaries of scene */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            didRotateFromInterfaceOrientation(UIInterfaceOrientation.Portrait)
            scene.size = CGSize(width: sWidth, height: sHeight)
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        sWidth = CGRectGetWidth(self.view.bounds)
        sHeight = CGRectGetHeight(self.view.bounds)
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
