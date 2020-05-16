//
//  GameScene.swift
//  Galaxy Hop
//
//  Created by Eva Gu on 4/16/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit
import GameplayKit

// shared struct across files, records info to be presented in Stats
struct StatsVars {
    static var highestScore : Int = 0
    static var lastScore : Int = 0
    static var totalScore : Int = 0
    static var gamesPlayed : Int = 0
}

class GameScene: SKScene {
    
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
            let sceneTwo = settings(fileNamed: "settings")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
