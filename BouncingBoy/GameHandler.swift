//
//  GameHandler.swift
//  BouncingBoy
//
//  Created by Robert Ogiba on 15.10.2017.
//  Copyright © 2017 Robert Ogiba. All rights reserved.
//

import Foundation

class GameHandler {
    var score: Int
    var highScore: Int
    
    var levelData: NSDictionary!
    
    static var shared: GameHandler = {
        let instance = GameHandler()
        return instance
    }()
    
    init() {
        score = 0
        highScore = 0
        
        let userDefaults = UserDefaults.standard
        
        highScore = userDefaults.integer(forKey: "highScore")
        
        if let path = Bundle.main.path(forResource: "Level01", ofType: "plist") {
            if let level = NSDictionary(contentsOfFile: path) {
                levelData = level
            }
        }
    }
    
    func saveGameStats() {
        highScore = max(score, highScore)
        
        UserDefaults.standard.set(highScore, forKey: "highScore")
        UserDefaults.standard.synchronize()
    }
}
