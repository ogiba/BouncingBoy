//
//  PlatformNode.swift
//  BouncingBoy
//
//  Created by Robert Ogiba on 15.10.2017.
//  Copyright © 2017 Robert Ogiba. All rights reserved.
//

import SpriteKit

class PlatformNode: GenericNode {
    var platformType: PlatformType!
    
    override func collistion(withPlayer player: SKNode) -> Bool {
        if player.physicsBody!.velocity.dy < 0 {
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 250)
            
            if platformType == .breakableBrick {
                self.removeFromParent()
            }
        }
        
        return false
    }
}
