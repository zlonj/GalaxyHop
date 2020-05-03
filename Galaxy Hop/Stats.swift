//
//  stats.swift
//  Galaxy Hop
//
//  Created by Bruce Jiang on 5/2/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit

class Stats : SKScene {
    
    private var label : SKLabelNode?
    private var player : SKSpriteNode?
    
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
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
}
