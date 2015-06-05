
//
//  Platform.swift
//  Tower
//
//  Created by Evil Cookie on 05/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import SpriteKit


class Platform: SKSpriteNode {
    
    init(imageNamed: String) {
        // render the platofrms by their image
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: nil, size: imageTexture.size())
        
        // use physicsbody to simulate gravity, should not happen for platforms
        self.physicsBody = SKPhysicsBody(rectangleOfSize: imageTexture.size())
        self.physicsBody?.dynamic = false
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

