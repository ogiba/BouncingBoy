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
    
    var currentMaxY: Int!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.blue
        let levelData = GameHandler.shared.levelData
        
        currentMaxY = 80
        GameHandler.shared.score = 0
        gameOver = false
        
        endOfGamePosition = (levelData!["EndOfLevel"] as AnyObject).integerValue
        
        scaleFactor = self.size.width / 320
        
        //        background = createBackground()
        //        addChild(background!)
        
        
        midground = createMidground()
        addChild(midground!)
        
        foreground = SKNode()
        addChild(foreground!)
        
        hud = SKNode()
        addChild(hud!)
        
        startButton.position = CGPoint(x: self.size.width / 2.0, y: 180)
        hud?.addChild(startButton)
        
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = SKColor.white
        scoreLabel?.position = CGPoint(x: self.size.width - 20, y: self.size.height - 40)
        scoreLabel?.horizontalAlignmentMode = .right
        
        scoreLabel?.text = "0"
        hud?.addChild(scoreLabel!)
        
        player = createPlayer()
        foreground?.addChild(player!)
        
        //        let platform = createPlatform(atPostion: CGPoint(x: 160, y: 320), ofType: .normalBrick)
        //        foreground?.addChild(platform)
        let platforms = levelData!["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            let x = (platformPosition["x"] as AnyObject).floatValue
            let y = (platformPosition["y"] as AnyObject).floatValue
            
            let pattern  = platformPosition["pattern"] as! NSString
            
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            
            for platformPoint in platformPattern {
                let xValue = (platformPoint["x"] as AnyObject).floatValue
                let yValue = (platformPoint["y"] as AnyObject).floatValue
                let type = PlatformType(rawValue: (platformPoint["type"] as AnyObject).integerValue)
                let xPosition = CGFloat(xValue! + x!)
                let yPosition = CGFloat(yValue! + y!)
                
                let platformNode = createPlatform(atPostion: CGPoint(x: xPosition, y: yPosition), ofType: type!)
                foreground?.addChild(platformNode)
            }
        }
        
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
        
        var updateHUD = false
        
        var otherNode:SKNode!
        
        if contact.bodyA.node != player {
            otherNode = contact.bodyA.node
        } else {
            otherNode = contact.bodyB.node
        }
        
        updateHUD = (otherNode as! GenericNode).collistion(withPlayer: player!)
        
        if updateHUD {
            scoreLabel?.text = "\(GameHandler.shared.score)"
        }
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
        if player!.physicsBody!.isDynamic {
            return
        }
        
        startButton.removeFromParent()
        
        player?.physicsBody?.isDynamic = true
        player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        foreground?.enumerateChildNodes(withName: "platformNode", using: { (node, stop) in
            let platform = node as! PlatformNode
            platform.shouldRemoveNode(playerY: self.player!.position.y)
        })
        
        if player!.position.y > 200 {
            background?.position = CGPoint(x: 0, y: -((player!.position.y - 200) / 10))
            midground?.position = CGPoint(x: 0, y: -((player!.position.y - 200) / 4))
            foreground?.position = CGPoint(x: 0, y: -((player!.position.y - 200)))
            
        }
        
        if Int(player!.position.y) > currentMaxY {
            GameHandler.shared.score += Int(player!.position.y) - currentMaxY
            currentMaxY = Int(player!.position.y)
            scoreLabel?.text = "\(GameHandler.shared.score)"
        }
        
        if Int(player!.position.y) > endOfGamePosition {
            endGame()
        }
        
        if Int(player!.position.y) < currentMaxY - 800 {
            endGame()
        }
    }
    
    func endGame() {
        gameOver = true
        GameHandler.shared.saveGameStats()
        
        let transition = SKTransition.fade(withDuration: 0.5)
    }
}
