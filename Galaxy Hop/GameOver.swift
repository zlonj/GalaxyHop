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
    private var PlayingTime: SKLabelNode!
    private var HighestTime : SKLabelNode!
    
    override func sceneDidLoad() {
        self.Score = self.childNode(withName: "Score") as? SKLabelNode
        self.HighestTime = self.childNode(withName: "HighestScore") as? SKLabelNode
        self.PlayingTime = self.childNode(withName: "PlayingTime") as? SKLabelNode
        self.HighestTime = self.childNode(withName: "HighestTime") as? SKLabelNode
        Score.text = String(gameOverData.score);
        if (gameOverData.score > GlobVariables.heighestScore) {
            GlobVariables.heighestScore = gameOverData.score
        }
        // need to update other data
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
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
}


