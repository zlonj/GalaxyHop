//
//  game2.swift
//  Galaxy Hop
//
//  Created by Eva Gu on 5/3/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


class game2: SKScene, SKPhysicsContactDelegate {
    private var player: SKSpriteNode!
    var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView) {
        self.player = self.childNode(withName: "player") as? SKSpriteNode
        self.player.texture = SKTexture(imageNamed: "characterWing.png")
        self.player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:88, height:60))
        self.player.physicsBody?.isDynamic = true
        self.player.physicsBody?.allowsRotation = false
        self.player.physicsBody?.affectedByGravity = false
        
        enumerateChildNodes(withName: "comet"){
            (node,stop) in
            let comet = node as! SKSpriteNode
            comet.texture = SKTexture(imageNamed: "comet.png")
            comet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 110, height: 110))
            comet.physicsBody?.isDynamic = true
            comet.physicsBody?.affectedByGravity = true
            comet.physicsBody?.linearDamping = 2.5
        }
        
        physicsWorld.contactDelegate = self
        self.player.physicsBody?.contactTestBitMask = self.player.physicsBody?.collisionBitMask ?? 0
        
        
        //tilt stuff
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkBounds()
        
        if let accelerometerData = motionManager.accelerometerData{
            self.player.physicsBody?.applyForce(CGVector(dx:  CGFloat(accelerometerData.acceleration.x * 3500), dy: 0))
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact did begin")
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else{return}
        
        if nodeA.name == "player"{
            collisionBetween(player: self.player, object: nodeB)
        }
        else if nodeB.name == "player"{
            collisionBetween(player: self.player, object: nodeA)
        }
    }
    func collisionBetween(player: SKNode, object: SKNode){
        if object.name == "comet"{
            let sceneTwo = GameOver(fileNamed: "GameOver")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
    func checkBounds(){
        let currX = self.player.position.x
         if currX > 310 {
             self.player.position.x = 310
         }
         if currX < -310 {
             self.player.position.x = -310
         }
        enumerateChildNodes(withName: "comet"){
        (node,stop) in
            if node.position.y < -670 {
                node.position.y += 3200
                let randomX = CGFloat.random(in: -250..<251)
                node.position.x = randomX
            }
        }
    }
    
    
}
