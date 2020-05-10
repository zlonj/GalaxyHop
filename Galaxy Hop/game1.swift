//
//  GameScene.swift
//  Galaxy Hop
//
//  Created by Eva Gu on 4/16/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

// shared struct between game and GameOver
struct gameOverData {
    static var score = 0
}

// background music
struct Music {
    static var valid = true;
}

// shared struct for pausing and transitioning
struct pauseData {
    static var valid : Bool = false
    static var score : Int = 0;
    static var platformPostions : [CGPoint] = [CGPoint.init(x: 0, y: 0), CGPoint.init(x: 0, y: 0), CGPoint.init(x: 0, y: 0), CGPoint.init(x: 0, y: 0), CGPoint.init(x: 0, y: 0), CGPoint.init(x: 0, y: 0)]
    static var charPostion : CGPoint = CGPoint.init()
}



class game1: SKScene, SKPhysicsContactDelegate {
    private var player : SKSpriteNode!
    private var platform: SKSpriteNode!
    private var score: SKLabelNode!
    var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView) {
        self.score = self.childNode(withName: "score") as? SKLabelNode
        self.player = self.childNode(withName: "player") as? SKSpriteNode
        self.player.texture = SKTexture(imageNamed: "character.png")
        self.player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:88, height:60))
        self.player.physicsBody?.isDynamic = true
        self.player.physicsBody?.allowsRotation = false
        self.player.physicsBody?.restitution = 1
        self.player.physicsBody?.linearDamping = 0.01
        self.player.physicsBody?.friction = 0
        
        self.platform = self.childNode(withName: "platform") as? SKSpriteNode
        self.platform.texture = SKTexture(imageNamed: "platform.png")
        self.platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 140, height: 10))
        self.platform.physicsBody?.isDynamic = false
        self.platform.physicsBody?.affectedByGravity = false
        
        enumerateChildNodes(withName: "platform"){
            (node,stop) in
            let platform = node as! SKSpriteNode
            platform.texture = SKTexture(imageNamed: "platform.png")
            platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 140, height: 10))
            platform.physicsBody?.isDynamic = false
            platform.physicsBody?.affectedByGravity = false
            platform.physicsBody?.friction = 0
        }
        
        
        physicsWorld.contactDelegate = self
        self.player.physicsBody?.contactTestBitMask = self.player.physicsBody?.collisionBitMask ?? 0
        
        
        //tilt stuff
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        // restore positions and score from pause or survival mode
        if pauseData.valid {
            var i = 0
            enumerateChildNodes(withName: "platform"){
                (node,stop) in
                node.position = pauseData.platformPostions[i]
                i += 1
            }
            self.player.position = CGPoint.init(x: pauseData.charPostion.x, y: pauseData.charPostion.y + 10)
            self.score.text = String(pauseData.score + 1)
            pauseData.valid = false
        }
    }
    
    
    // play/stop background music accordingly
    override func sceneDidLoad() {
        let bgm1 = SKAudioNode(fileNamed: "bgm1.mp3")
        self.addChild(bgm1)
        
        if Music.valid {
            bgm1.run(SKAction.play())
        } else {
            bgm1.run(SKAction.stop());
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //spawnAtRandomPosition()
        landingCheck()
        boundCheck()
        // hit top and refresh play screen
        hitTop()
        scoreCheck()
        if let body = self.player.physicsBody {
            let dy = body.velocity.dy
            if dy > 0 {
                // Prevent collisions if the hero is jumping
                body.collisionBitMask &= ~self.platform.physicsBody!.collisionBitMask
            }
            else {
                // Allow collisions if the hero is falling
                body.collisionBitMask |= self.platform.physicsBody!.collisionBitMask
            }
        }
        let currV = self.player.physicsBody?.velocity.dy
        print(currV!.description)
        if let accelerometerData = motionManager.accelerometerData{
            self.player.physicsBody?.applyForce(CGVector(dx:  CGFloat(accelerometerData.acceleration.x * 2000), dy: 0))
        }
        
        // platform falls when reaching certain height
        let currY = self.player.position.y
        if currY > -5 {
            self.player.position.y -= 5
            
            enumerateChildNodes(withName: "platform"){
                (node,stop) in
                node.position.y = node.position.y - 5
                if (node.position.y < -667) {
                    let randomX = CGFloat.random(in: -250..<251)
                    node.position.x = randomX
                    node.position.y = 667 - (-667 - node.position.y)
                }
            }
        }
        
    }
    
    // when reaching certain score, transition to survival mode
    func scoreCheck(){
        let currScore = Int(self.score.text!)!
        if currScore >= 50 && currScore % 50  == 0{
            // store positions and score
            var i : Int = 0
            enumerateChildNodes(withName: "platform"){
                (node,stop) in
                pauseData.platformPostions[i] = node.position
                i += 1
            }
            pauseData.valid = true
            pauseData.score = Int(self.score.text!)!
            pauseData.charPostion = player.position
            
            let sceneTwo = game2(fileNamed: "game2")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact did begin")
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else{return}
        let currV = self.player.physicsBody!.velocity.dy
        print("the velocity when currV was set:")
        print(currV.description)
        
        if nodeA.name == "player" && currV > 0{
            collisionBetween(player: self.player, object: nodeB)
        }
        else if nodeB.name == "player" && currV > 0{
            collisionBetween(player: self.player, object: nodeA)
        }
        
    }
    
    func collisionBetween(player: SKNode, object: SKNode){
        print("landed")
        if object.name == "platform"{
            var currScore = Int(self.score.text!)!
            currScore += 1
            gameOverData.score = currScore;
            self.score.text = String(currScore)
            self.player.physicsBody?.velocity.dy = 0
            self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 220))
            print("force applied")
        }
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
    
    func landingCheck() {
        let currY = self.player.position.y
        let playerH = self.frame.height
        if currY <= (-1 * playerH + 173){
            print("fell off")
            // jump to GameOver Scene
            let sceneTwo = GameOver(fileNamed: "GameOver")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
    
    func boundCheck() {
        let currX = self.player.position.x
        if currX > 370 {
            self.player.position.x = currX - 750
        }
        if currX < -370 {
            self.player.position.x = currX + 750
        }
    }
    
    func hitTop(){
        let currY = self.player.position.y
        if currY > 640{
            self.player.position.y = (-1 * currY) + 160
            
            enumerateChildNodes(withName: "platform"){
                (node,stop) in
                let randomX = CGFloat.random(in: -250..<251)
                node.position.x = randomX
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    // check if the player hits pause button
    func touchDown(atPoint pos : CGPoint) {
        let currX = pos.x
        let currY = pos.y
        // hit pause button
        if currX <= -205 && currX >= -319 && currY <= 633 && currY >= 519 {
            print("hit pause button")
            // store positions and score, set valid to true
            var i : Int = 0
            enumerateChildNodes(withName: "platform"){
                (node,stop) in
                pauseData.platformPostions[i] = node.position
                i += 1
            }
            pauseData.valid = true
            pauseData.score = Int(self.score.text!)!
            pauseData.charPostion = player.position
            let sceneTwo = pause(fileNamed: "pause")
            sceneTwo?.scaleMode = .aspectFill
            self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 1))
        }
    }
}
