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

class GameScene: SKScene {
    
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
        
        backgroundColor = SKColor.brown
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
