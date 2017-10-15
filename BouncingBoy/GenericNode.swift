//
//  GenericNode.swift
//  BouncingBoy
//
//  Created by Robert Ogiba on 15.10.2017.
//  Copyright © 2017 Robert Ogiba. All rights reserved.
//

import UIKit
import SpriteKit

struct CollistionBitMask {
    static let Player: UInt32 = 0x00
    static let Flower: UInt32 = 0x01
    static let Brick: UInt32 = 0x02
}

enum PlatformType: Int {
    case normalBrick = 0
    case breakableBrick = 1
}

class GenericNode: SKNode {
    func collistion(withPlayer player: SKNode) -> Bool {
        return false
    }
    
    func shouldRemoveNode(playerY: CGFloat) {
        if playerY > self.position.y + 300 {
            self.removeFromParent()
        }
    }
}
