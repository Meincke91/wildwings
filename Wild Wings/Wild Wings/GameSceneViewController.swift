//
//  FirstViewController.swift
//  Wild Wings 2
//
//  Created by Martin Meincke on 19/12/15.
//  Copyright © 2015 drades. All rights reserved.
//

import UIKit
import SpriteKit

var points: Int!
let obstacleChances = [200, 50, 10, 5, 10, 0]
let objectChances = [200, 100]

class GameSceneViewController: UIViewController, SKPhysicsContactDelegate {
    var scene: GameScene!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        // Configure view
        let skView = view as! SKView
        
        // Load the presentation logic
        scene = GameScene(size: skView.bounds.size)
        
        // present the scene
        scene.scaleMode = .aspectFill
        skView.showsPhysics = true;
        points = 0
        skView.presentScene(scene)
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = (touch as! UITouch).location(in: self.view)
            
            if scene.gameState == 1 {
                beginGame()
            } else if scene.gameState == 2 {
                scene.singleTap(location: location)
            }
        }
        super.touchesBegan(touches, with: event)
    }

    func beginGame(){
        scene.gameState = 2
        scene.startGame()
    }
}

