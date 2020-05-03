//
//  stats.swift
//  Galaxy Hop
//
//  Created by Bruce Jiang on 5/2/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit

class Stats : SKScene {
    
    private var player : SKSpriteNode?
    private var highestScore : SKLabelNode?
    private var lastScore : SKLabelNode?
    private var averageScore : SKLabelNode?
    
    override func sceneDidLoad() {
        self.highestScore = self.childNode(withName: "highestScore") as? SKLabelNode
        self.lastScore = self.childNode(withName: "lastScore") as? SKLabelNode
        self.averageScore = self.childNode(withName: "averageScore") as? SKLabelNode
        if String(StatsVars.heighestScore) > (highestScore?.text)! {
            highestScore?.text = String(StatsVars.heighestScore)
        }
        self.lastScore?.text = String(StatsVars.lastScore)
        if StatsVars.gamesPlayed == 0 {
            self.averageScore?.text = "0"
        } else {
            self.averageScore?.text = String(StatsVars.totalScore / StatsVars.gamesPlayed)
        }
    }
    
    override func didMove(to view: SKView) {
        self.player = self.childNode(withName: "playerWing") as? SKSpriteNode
        let dX = 0
        let dY = 100
        let moveActionUp = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(dY), duration: 1.0)
        let moveActionDown = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(-100), duration: 1.0)
        let sequence = SKAction.sequence([moveActionUp, moveActionDown]);
        let bounce = SKAction.repeatForever(sequence);
        player!.run(bounce)

    }
    
    func touchDown(atPoint pos : CGPoint) {
        let currX = pos.x
        let currY = pos.y
        if currX <= 274 && currX >= 58 && currY <= -382 && currY >= -598 {
           print("return to menu")
            let sceneTwo = GameScene(fileNamed: "GameScene")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
}
