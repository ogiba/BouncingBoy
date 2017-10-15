//
//  GameElements.swift
//  BouncingBoy
//
//  Created by Robert Ogiba on 07.10.2017.
//  Copyright © 2017 Robert Ogiba. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    func createBackground() -> SKNode  {
        let backgroundNode = SKNode()
        let spacing = 64 *   scaleFactor!
        
        for index in 0...19 {
            let node = SKSpriteNode(imageNamed: "")
            node.setScale(scaleFactor!)
            node.anchorPoint =  CGPoint(x: 0.5, y: 0)
            node.position = CGPoint(x: self.size.width / 2, y: spacing * CGFloat(index))
            
            backgroundNode.addChild(node)
        }
        
        return backgroundNode
    }
    
    func createMidground() -> SKNode {
        let midgroundNode = SKNode()
        var anchor: CGPoint?
        var xPos: CGFloat?
        
        for index in 0...9 {
            let randomNumber = arc4random() % 2
            let name: String
            
            if randomNumber > 0 {
                name = "leftCloud"
                anchor = CGPoint(x: 0, y: 0.5)
                xPos = 0
                
            } else {
                name = "rightCloud"
                anchor = CGPoint(x: 1, y: 0.5)
                xPos = self.size.width
            }
            
            let cloudNote = SKSpriteNode(imageNamed: name)
            cloudNote.anchorPoint = anchor!
            cloudNote.position = CGPoint(x: xPos!, y: 500 * CGFloat(index))
            
            midgroundNode.addChild(cloudNote)
        }
        
        return midgroundNode
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2.0, y: 80)
        
        let sprite = SKSpriteNode(imageNamed: "player")
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2.0)
        
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.allowsRotation = false

        playerNode.physicsBody?.restitution = 1
        playerNode.physicsBody?.friction = 0
        playerNode.physicsBody?.angularDamping = 0
        playerNode.physicsBody?.linearDamping = 0
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        
        playerNode.physicsBody?.categoryBitMask = CollistionBitMask.Player
        
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollistionBitMask.Brick
        
        return playerNode
    }
    
    func createPlatform(atPostion position: CGPoint, ofType type: PlatformType) -> PlatformNode {
        let node = PlatformNode()
        let position = CGPoint(x: position.x * scaleFactor!, y: position.y)
        node.position = position
        node.name = "platformNode"
        node.platformType = type
        
        var sprite: SKSpriteNode
        
        switch type {
        case .normalBrick:
            sprite = SKSpriteNode(imageNamed: "platform")
        case .breakableBrick:
            sprite = SKSpriteNode(imageNamed: "platformBreakable")
        }
        
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollistionBitMask.Brick
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
}

