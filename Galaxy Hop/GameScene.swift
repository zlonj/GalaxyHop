//
//  GameScene.swift
//  Galaxy Hop
//
//  Created by Eva Gu on 4/16/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit
import GameplayKit

struct StatsVars {
    static var heighestScore : Int = 0;
    static var lastScore : Int = 0;
    static var totalScore : Int = 0;
    static var gamesPlayed : Int = 0;
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var player : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    
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
    
    
    func touchDown(atPoint pos : CGPoint) {
        let currX = pos.x
        let currY = pos.y
        if currX <= 29 && currX >= -320 && currY <= 85 && currY >= -265 {
            print("hit play button")
            let sceneTwo = game1(fileNamed: "game1")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
        if currX <= 287 && currX >= 37 && currY <= 40 && currY >= -210 {
            print("hit stats button")
            let sceneTwo = Stats(fileNamed: "Stats")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
        if currX <= 186 && currX >= -64 && currY <= -230 && currY >= -480 {
            print("hit settings button")
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos    
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //spawnAtRandomPosition()
    }
    func spawnAtRandomPosition() {
        let height = UInt32(self.size.height)
        let width = UInt32(self.size.width)

        let randomPosition = CGPoint(x: Int(arc4random_uniform(width)), y: Int(arc4random_uniform(height)))

        let sprite = SKSpriteNode(imageNamed: "platform")
        sprite.position = randomPosition
        sprite.zPosition = 1
        self.addChild(sprite)
    }
}
