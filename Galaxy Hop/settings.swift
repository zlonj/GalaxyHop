//
//  settings.swift
//  Galaxy Hop
//
//  Created by Bruce Jiang on 5/15/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit

class settings : SKScene {
    
    private var player : SKSpriteNode?
    private var musicLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        self.player = self.childNode(withName: "player") as? SKSpriteNode
        let dX = 0
        let dY = 100
        let moveActionUp = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(dY), duration: 1.0)
        let moveActionDown = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(-100), duration: 1.0)
        let sequence = SKAction.sequence([moveActionUp, moveActionDown]);
        let bounce = SKAction.repeatForever(sequence);
        player!.run(bounce)
    }
    
    // load correct text for button accordingly
    override func sceneDidLoad() {
        self.musicLabel = self.childNode(withName: "musicLabel") as? SKLabelNode
        if Music.turnOff {
            musicLabel?.text = "Turn On Music"
        } else {
            musicLabel?.text = "Turn Off Music"
        }
    }
    
    // check which button is pressed
    func touchDown(atPoint pos : CGPoint) {
        let currX = pos.x
        let currY = pos.y
        // turn off/on music
        if currX <= 144.71 && currX >= -145.91 && currY <= 209 && currY >= -81 {
            print("turn on/off music")
            Music.turnOff = !Music.turnOff
            if Music.turnOff {
                musicLabel?.text = "Turn On Music"
            } else {
                musicLabel?.text = "Turn Off Music"
            }
            print(Music.turnOff)
            // store the setting into NSUserDefaults
            UserDefaults.standard.set(Music.turnOff, forKey: "music")
            
        }
        // reset stats
        if currX <= 144.71 && currX >= -145.91 && currY <= -167 && currY >= -447 {
            print("reset stats")
            StatsVars.gamesPlayed = 0
            StatsVars.highestScore = 0
            StatsVars.lastScore = 0
            StatsVars.totalScore  = 0
            // store reset values
            UserDefaults.standard.set(StatsVars.highestScore, forKey: "highestScore")
            UserDefaults.standard.set(StatsVars.lastScore, forKey: "lastScore")
            UserDefaults.standard.set(StatsVars.totalScore, forKey: "totalScore")
            UserDefaults.standard.set(StatsVars.gamesPlayed, forKey: "gamesPlayed")
        }
        if currX <= 302 && currX >= 80 && currY <= -418 && currY >= -640 {
            print("back to home")
            let sceneTwo = GameScene(fileNamed: "GameScene")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}
