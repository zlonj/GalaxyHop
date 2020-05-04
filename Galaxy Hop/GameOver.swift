//
//  GameOver.swift
//  Galaxy Hop
//
//  Created by Bruce Jiang on 5/3/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit

class GameOver : SKScene {
    
    private var Score : SKLabelNode!
    private var HighestScore: SKLabelNode!
    
    override func sceneDidLoad() {
        self.Score = self.childNode(withName: "Score") as? SKLabelNode
        self.HighestScore = self.childNode(withName: "HighestScore") as? SKLabelNode
        Score.text = String(gameOverData.score);
        // update vars, such as highestScore, lastScore, gamesPlayed, totalScore
        if (gameOverData.score < StatsVars.highestScore) {
            self.HighestScore.text = String(StatsVars.highestScore)
        } else {
            StatsVars.highestScore = gameOverData.score
            self.HighestScore.text = String(gameOverData.score)
        }
        StatsVars.gamesPlayed += 1
        StatsVars.lastScore = gameOverData.score
        StatsVars.totalScore += gameOverData.score
        pauseData.valid = false
        
        // store StatsVars into NSUserDefaults
        UserDefaults.standard.set(StatsVars.highestScore, forKey: "highestScore")
        UserDefaults.standard.set(StatsVars.lastScore, forKey: "lastScore")
        UserDefaults.standard.set(StatsVars.totalScore, forKey: "totalScore")
        UserDefaults.standard.set(StatsVars.gamesPlayed, forKey: "gamesPlayed")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let currX = pos.x
        let currY = pos.y
        if currX <= 277.5 && currX >= 42.5 && currY <= -362.5 && currY >= -597.5 {
           print("return to menu")
            let sceneTwo = GameScene(fileNamed: "GameScene")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
        if currX <= -63.5 && currX >= -298.85 && currY <= -362.5 && currY >= -597.5 {
           print("play again")
            let sceneTwo = game1(fileNamed: "game1")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
}


