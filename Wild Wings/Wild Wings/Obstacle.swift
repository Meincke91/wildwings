//
//  Obstacle.swift
//  Wild Wings 2
//
//  Created by Martin Meincke on 24/02/16.
//  Copyright © 2016 drades. All rights reserved.
//

import SpriteKit

enum ObstacleType: Int{
    // Blank = Completely unused fields(usually marked with a grey field)
    case empty, smallBranch, shortBranch, hollowTree, longBranch, hollowBird
}

class Obstacle {
    private var obstacleSprite: SKSpriteNode!
    private var obstacleType: ObstacleType!
    
    init(type: ObstacleType, position: CGPoint, colision: Bool){
        self.obstacleType = type
        self.obstacleSprite = SKSpriteNode(imageNamed: String(describing: type))
        self.obstacleSprite.zPosition = 5
        self.obstacleSprite.anchorPoint = CGPoint.zero
        //self.obstacleSprite.position = CGPointMake(self.getObstacleSprite().frame.width/2, self.getObstacleSprite().frame.height/2)
        if colision{
            self.obstacleSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: obstacleSprite.frame)
            self.obstacleSprite.physicsBody!.affectedByGravity = false
            self.obstacleSprite.physicsBody!.categoryBitMask = ColliderType.obstacle.rawValue
            self.obstacleSprite.physicsBody!.contactTestBitMask = ColliderType.playerCol.rawValue
        }
        
        self.obstacleSprite.position = position
    }
    
    func addAction(action: SKAction){
        self.getObstacleSprite().run(action)
    }
    
    func removeAllAction(){
        self.getObstacleSprite().removeAllActions()
    }
    
    func removeObstacleSprite(){
        self.obstacleSprite.removeFromParent()
        self.obstacleSprite = nil
    }
    
    // getters and setters
    
    func getObstacleType() -> ObstacleType{
        return self.obstacleType
    }
    func getObstacleSprite() -> SKSpriteNode{
        return self.obstacleSprite
    }
    
    func setPosition(position: CGPoint){
        obstacleSprite.position = position
    }
    
}
