//
//  GameScene.swift
//  Galaxy Hop
//
//  Created by Eva Gu on 4/16/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit
import GameplayKit


class game1: SKScene, SKPhysicsContactDelegate {
    private var player : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.player = self.childNode(withName: "player") as? SKSpriteNode
        self.player?.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "character.png"), size: CGSize(width: 348.24, height: 346.463))

    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //spawnAtRandomPosition()
    }
    func bounceUp(){
        let dX = 0
        let dY = 100
        let moveActionUp = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(dY), duration: 1.0)
        player!.run(moveActionUp)
    }
    func spawnAtRandomPosition() {
        let height = UInt32(self.size.height)
        let width = UInt32(self.size.width)

        let randomPosition = CGPoint(x: Int(arc4random_uniform(width)), y: Int(arc4random_uniform(height)))

        let sprite = SKSpriteNode(imageNamed: "platform")
        sprite.position = randomPosition
        let newSize = CGSize(width: 300, height: 300)
        sprite.size = newSize
        self.addChild(sprite)
    }
}
