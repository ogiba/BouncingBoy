//
//  GameScene.swift
//  BouncingBoy
//
//  Created by Robert Ogiba on 07.09.2017.
//  Copyright © 2017 Robert Ogiba. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: SKNode?
    var midground: SKNode?
    var foreground: SKNode?
    
    var hud: SKNode?
    
    var player: SKNode?
    
    var scaleFactor: CGFloat?
    
    var startButton = SKSpriteNode(imageNamed: "TapToStart")
    
    var endOfGamePosition = 0
    
    let motionManager = CMMotionManager()
    
    var xAcceleration: CGFloat = 0.0
    
    var scoreLabel: SKLabelNode?
    
    var flowerLabel: SKLabelNode?
    
    var playersMaxY:Int?
    
    var gameOver = false
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.blue
        
        scaleFactor = self.size.width / 320
        
//        background = createBackground()
//        addChild(background!)
        
        midground = createMidground()
        addChild(midground!)
        
        foreground = SKNode()
        addChild(foreground!)
        
        player = createPlayer()
        foreground?.addChild(player!)
        
        let platform = createPlatform(atPostion: CGPoint(x: 160, y: 320), ofType: .normalBrick)
        foreground?.addChild(platform)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate = self
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75) + (self.xAcceleration * 0.25)
            }
        }
     }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var otherNode:SKNode!
        
        if contact.bodyA.node != player {
            otherNode = contact.bodyA.node
        } else {
            otherNode = contact.bodyB.node
        }
        
        (otherNode as! GenericNode).collistion(withPlayer: player!)
    }
    
    override func didSimulatePhysics() {
        player?.physicsBody?.velocity = CGVector(dx: xAcceleration * 400, dy: player!.physicsBody!.velocity.dy)
        
        if player!.position.x < -20 {
            player?.position = CGPoint(x: self.size.width + 20, y: player!.position.y)
        }else if (player!.position.x > self.size.width + 20){
            player?.position = CGPoint(x: -20, y: player!.position.y)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.physicsBody?.isDynamic = true
        player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
