//
//  ActionObject.swift
//  Wild Wings 2
//
//  Created by Martin Meincke on 23/03/16.
//  Copyright © 2016 drades. All rights reserved.
//

import SpriteKit

enum ObjectType: Int{
    // Blank = Completely unused fields(usually marked with a grey field)
    case empty, dradesCoin
}

class ActionObject {
    var type: ObjectType!
    var ObjectSprite: SKSpriteNode!
    init(type: ObjectType, position: CGPoint, colliderType: ColliderType, colision: Bool){
        self.ObjectSprite = SKSpriteNode(imageNamed: String(describing: type))
        
        self.ObjectSprite.zPosition = 5
        self.ObjectSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: ObjectSprite.frame)
        self.ObjectSprite.physicsBody!.affectedByGravity = false
        self.ObjectSprite.physicsBody!.categoryBitMask = colliderType.rawValue
        self.ObjectSprite.physicsBody!.contactTestBitMask = ColliderType.playerCol.rawValue
        self.ObjectSprite.position = position
        self.type = type
    }
    
    
    // getters and setters
    func getType() -> ObjectType{
        return self.type
    }
    
    func getSprite() -> SKSpriteNode{
        return self.ObjectSprite
    }
    
    func addAction(action: SKAction){
        ObjectSprite.run(action)
    }
}
