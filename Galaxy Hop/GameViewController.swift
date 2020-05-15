//
//  GameViewController.swift
//  Galaxy Hop
//
//  Created by Eva Gu on 4/16/20.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        // retrieve StatsVars from NSUserDefaults
        StatsVars.highestScore = UserDefaults.standard.integer(forKey: "highestScore")
        StatsVars.lastScore = UserDefaults.standard.integer(forKey: "lastScore")
        StatsVars.totalScore = UserDefaults.standard.integer(forKey: "totalScore")
        StatsVars.gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed")
        Music.turnOff = UserDefaults.standard.bool(forKey: "music")
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
